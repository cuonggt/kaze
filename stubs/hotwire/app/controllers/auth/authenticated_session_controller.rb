class Auth::AuthenticatedSessionController < ApplicationController
  include RedirectIfAuthenticated
  include SetTwoFactorChallenge

  skip_authenticate only: %i[new create]
  skip_redirect_if_authenticated only: :destroy
  skip_ensure_email_is_verified only: :destroy

  layout 'guest'

  def new
    @form = Auth::LoginForm.new

    render 'auth/login'
  end

  def create
    @form = Auth::LoginForm.new(params.permit(:email, :password, :remember))

    @form.authenticate

    return render 'auth/login', status: :unprocessable_entity if @form.user.nil?

    return redirect_to two_factor_challenge_path if start_two_factor_challenge(@form)

    Current.auth.login(@form.user, @form.remember)

    redirect_to dashboard_path
  end

  def destroy
    Current.auth.logout

    reset_session

    redirect_to '/'
  end

  private
    # A correct password is not a session when a second factor is owed. Hold the
    # user in the challenge instead and let them prove the rest.
    def start_two_factor_challenge(form)
      return false unless form.user.two_factor_enabled?

      two_factor_challenge.start(form.user, remember: form.remember.present?)

      true
    end
end
