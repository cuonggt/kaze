class Settings::TwoFactorController < ApplicationController
  skip_ensure_email_is_verified

  def edit
    @confirm_form = ConfirmTwoFactorForm.new
    @disable_form = DisableTwoFactorForm.new

    render 'settings/two_factor/edit'
  end

  # Starts setup. The account is not protected until the code is confirmed, so
  # this is safe to call again to start over.
  def create
    Current.auth.user.prepare_two_factor

    redirect_to two_factor_edit_path
  end

  def update
    @confirm_form = ConfirmTwoFactorForm.new(params.permit(:code))
    @disable_form = DisableTwoFactorForm.new

    unless @confirm_form.valid? && Current.auth.user.confirm_two_factor(@confirm_form.code)
      @confirm_form.errors.add(:code, message: 'That code is not valid.') if @confirm_form.errors[:code].empty?

      return render 'settings/two_factor/edit', status: :unprocessable_entity
    end

    redirect_to two_factor_edit_path, flash: { status: 'two-factor-enabled' }
  end

  def destroy
    @confirm_form = ConfirmTwoFactorForm.new
    @disable_form = DisableTwoFactorForm.new(params.permit(:password))

    return render 'settings/two_factor/edit', status: :unprocessable_entity if @disable_form.invalid?

    Current.auth.user.disable_two_factor

    redirect_to two_factor_edit_path
  end

  def recovery_codes
    Current.auth.user.regenerate_two_factor_recovery_codes

    redirect_to two_factor_edit_path, flash: { status: 'recovery-codes-generated' }
  end
end
