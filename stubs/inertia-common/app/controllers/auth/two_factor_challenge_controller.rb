class Auth::TwoFactorChallengeController < ApplicationController
  include RedirectIfAuthenticated
  include SetTwoFactorChallenge

  skip_authenticate
  before_action :ensure_challenge_is_pending

  # Six digits is small enough to guess given enough tries, so the attempts are
  # capped. Keyed on the account being challenged rather than the address, so
  # moving between addresses does not buy more attempts.
  rate_limit to: 5,
    within: 1.minute,
    by: -> { two_factor_challenge.user&.id || request.remote_ip },
    with: -> { too_many_attempts },
    only: :create

  def new
    render inertia: 'Auth/TwoFactorChallenge'
  end

  def create
    form = Auth::TwoFactorChallengeForm.new(params.permit(:code, :recovery_code))

    form.authenticate(two_factor_challenge.user)

    return redirect_to two_factor_challenge_path, inertia: { errors: form.error_messages } if form.errors.any?

    complete_login
  end

  private

    def too_many_attempts
      redirect_to two_factor_challenge_path,
        inertia: { errors: { code: 'Too many attempts. Try again in a minute.' } }
    end
    def ensure_challenge_is_pending
      redirect_to login_path unless two_factor_challenge.pending?
    end

    # The session id is rotated on the way in, so a session fixed before the
    # password was given cannot survive the second factor.
    def complete_login
      user = two_factor_challenge.user
      remember = two_factor_challenge.remember?

      reset_session

      Current.auth.login(user, remember)

      redirect_to dashboard_path
    end
end
