require 'test_helper'

class Auth::RateLimitingTest < ActionDispatch::IntegrationTest
  setup do
    @user = FactoryBot.create(:user)
  end

  test 'login attempts are capped' do
    11.times do
      post login_path, params: { email: @user.email, password: 'wrong-password' }
    end

    # The cap holds even when the password is finally right, so guessing cannot
    # be mixed with a known-good attempt to slip through. Asserting this rather
    # than the status, which differs between the stacks.
    post login_path, params: { email: @user.email, password: 'password' }

    assert_guest
  end

  test 'the login cap is per email, so one account being attacked does not lock out another' do
    other = FactoryBot.create(:user)

    11.times do
      post login_path, params: { email: @user.email, password: 'wrong-password' }
    end

    post login_path, params: { email: other.email, password: 'password' }

    assert_authenticated
  end

  test 'two factor attempts are capped' do
    @user.prepare_two_factor
    @user.confirm_two_factor(ROTP::TOTP.new(@user.two_factor_secret).now)

    post login_path, params: { email: @user.email, password: 'password' }

    6.times do
      post two_factor_challenge_store_path, params: { code: '000000' }
    end

    # The real code does not get through either, so an attacker cannot burn
    # guesses and then wait for a window.
    post two_factor_challenge_store_path, params: { code: ROTP::TOTP.new(@user.two_factor_secret).now }

    assert_guest
  end

  test 'a correct code within the cap still works' do
    @user.prepare_two_factor
    @user.confirm_two_factor(ROTP::TOTP.new(@user.two_factor_secret).now)

    post login_path, params: { email: @user.email, password: 'password' }

    2.times do
      post two_factor_challenge_store_path, params: { code: '000000' }
    end

    post two_factor_challenge_store_path, params: { code: ROTP::TOTP.new(@user.two_factor_secret).now }

    assert_authenticated
  end
end
