class Settings::TwoFactorController < ApplicationController
  skip_ensure_email_is_verified

  def edit
    render inertia: 'Settings/TwoFactor', props: two_factor_props
  end

  # Starts setup. The account is not protected until the code is confirmed, so
  # this is safe to call again to start over.
  def create
    Current.auth.user.prepare_two_factor

    redirect_to two_factor_edit_path
  end

  def update
    form = ConfirmTwoFactorForm.new(params.permit(:code))

    unless form.valid? && Current.auth.user.confirm_two_factor(form.code)
      form.errors.add(:code, message: 'That code is not valid.') if form.errors[:code].empty?

      return redirect_to two_factor_edit_path, inertia: { errors: form.error_messages }
    end

    redirect_to two_factor_edit_path, flash: { status: 'two-factor-enabled' }
  end

  def destroy
    form = DisableTwoFactorForm.new(params.permit(:password))

    return redirect_to two_factor_edit_path, inertia: { errors: form.error_messages } if form.invalid?

    Current.auth.user.disable_two_factor

    redirect_to two_factor_edit_path
  end

  def recovery_codes
    Current.auth.user.regenerate_two_factor_recovery_codes

    redirect_to two_factor_edit_path, flash: { status: 'recovery-codes-generated' }
  end

  private
    # The QR code and the secret are only sent while setup is unfinished, and
    # the recovery codes only once it is done -- neither needs to be on the
    # wire at any other time.
    def two_factor_props
      user = Current.auth.user

      {
        enabled: user.two_factor_enabled?,
        pending: user.two_factor_pending?,
        qrCode: user.two_factor_pending? ? user.two_factor_qr_code_svg : nil,
        secret: user.two_factor_pending? ? user.two_factor_secret : nil,
        recoveryCodes: user.two_factor_enabled? ? user.two_factor_recovery_codes_list : [],
        status: flash[:status]
      }
    end
end
