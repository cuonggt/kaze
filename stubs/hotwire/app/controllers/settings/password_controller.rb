class Settings::PasswordController < ApplicationController
  skip_ensure_email_is_verified

  def edit
    @update_password_form = UpdatePasswordForm.new

    render 'settings/password/edit'
  end

  def update
    @update_password_form = UpdatePasswordForm.new(params.permit(:current_password, :password, :password_confirmation))

    return render partial: 'settings/password/update_password_form', status: :unprocessable_entity if @update_password_form.invalid?

    Current.auth.user.update(password: @update_password_form.password)

    redirect_back_or_to password_edit_path, flash: { status: 'password-updated' }
  end
end
