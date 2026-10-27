require 'test_helper'

class Auth::TwoFactorChallengeTest < ActionDispatch::IntegrationTest
  setup do
    @user = FactoryBot.create(:user)
    @user.prepare_two_factor
    @user.confirm_two_factor(code_for(@user))
  end

  # The point of the whole thing: a correct password alone is not a session.
  test 'a correct password does not log in a user with two factor enabled' do
    post login_path, params: { email: @user.email, password: 'password' }

    assert_guest
    assert_redirected_to two_factor_challenge_path
  end

  test 'a user without two factor still logs straight in' do
    other = FactoryBot.create(:user)

    post login_path, params: { email: other.email, password: 'password' }

    assert_authenticated
    assert_redirected_to dashboard_path
  end

  test 'the challenge screen can be rendered once a password has been given' do
    post login_path, params: { email: @user.email, password: 'password' }

    get two_factor_challenge_path

    assert_response :success
  end

  test 'the challenge screen is not reachable without giving a password first' do
    get two_factor_challenge_path

    assert_redirected_to login_path
  end

  test 'a correct code completes the login' do
    post login_path, params: { email: @user.email, password: 'password' }

    post two_factor_challenge_store_path, params: { code: code_for(@user) }

    assert_authenticated
    assert_redirected_to dashboard_path
  end

  test 'a wrong code does not complete the login' do
    post login_path, params: { email: @user.email, password: 'password' }

    post two_factor_challenge_store_path, params: { code: '000000' }

    assert_guest
  end

  test 'submitting nothing does not complete the login' do
    post login_path, params: { email: @user.email, password: 'password' }

    post two_factor_challenge_store_path, params: {}

    assert_guest
  end

  test 'a recovery code completes the login and is then spent' do
    recovery_code = @user.two_factor_recovery_codes_list.first

    post login_path, params: { email: @user.email, password: 'password' }
    post two_factor_challenge_store_path, params: { recovery_code: recovery_code }

    assert_authenticated
    assert_not_includes @user.reload.two_factor_recovery_codes_list, recovery_code
  end

  test 'a spent recovery code does not work twice' do
    recovery_code = @user.two_factor_recovery_codes_list.first

    post login_path, params: { email: @user.email, password: 'password' }
    post two_factor_challenge_store_path, params: { recovery_code: recovery_code }
    post logout_path

    post login_path, params: { email: @user.email, password: 'password' }
    post two_factor_challenge_store_path, params: { recovery_code: recovery_code }

    assert_guest
  end

  test 'a challenge left too long expires' do
    post login_path, params: { email: @user.email, password: 'password' }

    travel TwoFactorChallenge::EXPIRES_IN + 1.minute do
      post two_factor_challenge_store_path, params: { code: code_for(@user) }

      assert_guest
      assert_redirected_to login_path
    end
  end

  test 'the challenge is cleared once it has been used' do
    post login_path, params: { email: @user.email, password: 'password' }
    post two_factor_challenge_store_path, params: { code: code_for(@user) }
    post logout_path

    get two_factor_challenge_path

    assert_redirected_to login_path
  end

  private
    def code_for(user)
      ROTP::TOTP.new(user.two_factor_secret).now
    end
end
