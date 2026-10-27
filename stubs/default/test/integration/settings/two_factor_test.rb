require 'test_helper'

class Settings::TwoFactorTest < ActionDispatch::IntegrationTest
  setup do
    @user = FactoryBot.create(:user)
  end

  test 'the page is displayed' do
    acting_as(@user).get two_factor_edit_path

    assert_response :success
  end

  test 'the page requires a login' do
    get two_factor_edit_path

    assert_redirected_to login_path
  end

  test 'starting setup generates a secret without enabling anything' do
    acting_as(@user).post two_factor_store_path

    @user.reload

    assert @user.two_factor_pending?
    assert_not @user.two_factor_enabled?
  end

  test 'a correct code finishes setup' do
    acting_as(@user).post two_factor_store_path
    @user.reload

    patch two_factor_update_path, params: { code: code_for(@user) }

    assert @user.reload.two_factor_enabled?
  end

  test 'a wrong code does not finish setup' do
    acting_as(@user).post two_factor_store_path

    patch two_factor_update_path, params: { code: '000000' }

    assert_not @user.reload.two_factor_enabled?
  end

  test 'an empty code does not finish setup' do
    acting_as(@user).post two_factor_store_path

    patch two_factor_update_path, params: {}

    assert_not @user.reload.two_factor_enabled?
  end

  test 'recovery codes can be regenerated' do
    enable_two_factor

    before = @user.reload.two_factor_recovery_codes_list

    post two_factor_recovery_codes_path

    assert_not_equal before, @user.reload.two_factor_recovery_codes_list
  end

  # Turning the protection off is the dangerous direction, so it asks for the
  # password rather than trusting the session alone.
  test 'the current password is required to turn it off' do
    enable_two_factor

    delete two_factor_destroy_path, params: { password: 'wrong-password' }

    assert @user.reload.two_factor_enabled?
  end

  test 'no password at all does not turn it off' do
    enable_two_factor

    delete two_factor_destroy_path, params: {}

    assert @user.reload.two_factor_enabled?
  end

  test 'the correct password turns it off and clears everything' do
    enable_two_factor

    delete two_factor_destroy_path, params: { password: 'password' }

    @user.reload

    assert_not @user.two_factor_enabled?
    assert_nil @user.two_factor_secret
    assert_empty @user.two_factor_recovery_codes_list
  end

  private
    def code_for(user)
      ROTP::TOTP.new(user.two_factor_secret).now
    end

    def enable_two_factor
      acting_as(@user).post two_factor_store_path
      @user.reload
      patch two_factor_update_path, params: { code: code_for(@user) }
    end
end
