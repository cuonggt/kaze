require 'test_helper'

class TwoFactorAuthenticatableTest < ActiveSupport::TestCase
  setup do
    @user = FactoryBot.create(:user)
  end

  test 'a new user has two factor disabled' do
    assert_not @user.two_factor_enabled?
    assert_not @user.two_factor_pending?
    assert_empty @user.two_factor_recovery_codes_list
  end

  test 'preparing generates a secret and recovery codes but does not enable' do
    @user.prepare_two_factor

    assert @user.two_factor_secret.present?
    assert_equal TwoFactorAuthenticatable::RECOVERY_CODE_COUNT, @user.two_factor_recovery_codes_list.length
    assert @user.two_factor_pending?
    assert_not @user.two_factor_enabled?
  end

  test 'preparing again replaces an unfinished attempt' do
    @user.prepare_two_factor
    first_secret = @user.two_factor_secret

    @user.prepare_two_factor

    assert_not_equal first_secret, @user.two_factor_secret
  end

  test 'a correct code confirms, and only then is it enabled' do
    @user.prepare_two_factor

    assert @user.confirm_two_factor(current_code)
    assert @user.two_factor_enabled?
    assert_not @user.two_factor_pending?
  end

  test 'a wrong code does not confirm' do
    @user.prepare_two_factor

    assert_not @user.confirm_two_factor('000000')
    assert_not @user.two_factor_enabled?
  end

  test 'confirming does nothing when nothing is pending' do
    assert_not @user.confirm_two_factor('000000')
  end

  test 'codes verify only against the right secret' do
    @user.prepare_two_factor

    assert @user.verify_two_factor_code(current_code)
    assert_not @user.verify_two_factor_code('000000')
    assert_not @user.verify_two_factor_code('')
    assert_not @user.verify_two_factor_code(nil)
  end

  test 'a code from a different secret is rejected' do
    @user.prepare_two_factor
    other = ROTP::TOTP.new(ROTP::Base32.random).now

    assert_not @user.verify_two_factor_code(other)
  end

  test 'recovery codes are single use' do
    @user.prepare_two_factor
    code = @user.two_factor_recovery_codes_list.first

    assert @user.consume_two_factor_recovery_code(code)
    assert_not_includes @user.two_factor_recovery_codes_list, code
    assert_not @user.consume_two_factor_recovery_code(code)
  end

  test 'consuming an unknown recovery code leaves the rest alone' do
    @user.prepare_two_factor
    before = @user.two_factor_recovery_codes_list

    assert_not @user.consume_two_factor_recovery_code('not-a-code')
    assert_equal before, @user.two_factor_recovery_codes_list
  end

  test 'recovery codes can be regenerated without touching the secret' do
    @user.prepare_two_factor
    secret = @user.two_factor_secret
    before = @user.two_factor_recovery_codes_list

    @user.regenerate_two_factor_recovery_codes

    assert_equal secret, @user.two_factor_secret
    assert_not_equal before, @user.two_factor_recovery_codes_list
    assert_equal TwoFactorAuthenticatable::RECOVERY_CODE_COUNT, @user.two_factor_recovery_codes_list.length
  end

  test 'disabling clears everything' do
    @user.prepare_two_factor
    @user.confirm_two_factor(current_code)

    @user.disable_two_factor

    assert_nil @user.two_factor_secret
    assert_nil @user.two_factor_confirmed_at
    assert_empty @user.two_factor_recovery_codes_list
    assert_not @user.two_factor_enabled?
  end

  test 'the provisioning uri carries the secret and the account' do
    @user.prepare_two_factor
    uri = @user.two_factor_provisioning_uri(issuer: 'Kaze')

    assert_includes uri, @user.two_factor_secret
    assert_includes uri, 'issuer=Kaze'
  end

  test 'there is no provisioning uri or qr code without a secret' do
    assert_nil @user.two_factor_provisioning_uri
    assert_nil @user.two_factor_qr_code_svg
  end

  test 'the qr code is an svg' do
    @user.prepare_two_factor

    assert_match(/<svg/, @user.two_factor_qr_code_svg)
  end

  # The secret is the whole of the second factor, so it must not sit in the
  # database in the clear.
  test 'the secret and recovery codes are encrypted at rest' do
    @user.prepare_two_factor

    row = User.lease_connection.select_one("SELECT two_factor_secret, two_factor_recovery_codes FROM users WHERE id = #{@user.id}")

    assert_not_equal @user.two_factor_secret, row['two_factor_secret']
    assert_not_includes row['two_factor_secret'].to_s, @user.two_factor_secret
    assert_not_includes row['two_factor_recovery_codes'].to_s, @user.two_factor_recovery_codes_list.first
  end

  private
    def current_code
      ROTP::TOTP.new(@user.two_factor_secret).now
    end
end
