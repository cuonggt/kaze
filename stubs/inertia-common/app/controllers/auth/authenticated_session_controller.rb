class Auth::AuthenticatedSessionController < ApplicationController
  include RedirectIfAuthenticated
  include SetTwoFactorChallenge

  skip_authenticate only: %i[new create]
  skip_redirect_if_authenticated only: :destroy
  skip_ensure_email_is_verified only: :destroy

  # Passwords are stronger than a six digit code, but not so strong that
  # unlimited guesses are safe. Keyed on the email being tried.
  rate_limit to: 10,
    within: 1.minute,
    by: -> { params[:email].to_s.strip.downcase.presence || request.remote_ip },
    with: -> { too_many_attempts },
    only: :create

  def new
    render inertia: 'Auth/Login', props: {
      status: flash[:status]
    }
  end

  def create
    form = Auth::LoginForm.new(params.permit(:email, :password, :remember))

    form.authenticate

    return redirect_back_or_to login_path, inertia: { errors: form.error_messages } if form.user.nil?

    return redirect_to two_factor_challenge_path if start_two_factor_challenge(form)

    Current.auth.login(form.user, form.remember)

    redirect_to dashboard_path
  end

  def destroy
    Current.auth.logout

    reset_session

    redirect_to '/'
  end

  private

    def too_many_attempts
      redirect_to login_path,
        inertia: { errors: { email: 'Too many attempts. Try again in a minute.' } }
    end
    # A correct password is not a session when a second factor is owed. Hold the
    # user in the challenge instead and let them prove the rest.
    def start_two_factor_challenge(form)
      return false unless form.user.two_factor_enabled?

      two_factor_challenge.start(form.user, remember: form.remember.present?)

      true
    end
end
