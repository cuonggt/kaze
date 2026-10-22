class Settings::ProfileController < ApplicationController
  skip_ensure_email_is_verified

  def edit
    @update_profile_information_form = UpdateProfileInformationForm.new(name: Current.auth.user.name, email: Current.auth.user.email)
    @delete_user_form = DeleteUserForm.new

    render 'settings/profile/edit'
  end

  def update
    @update_profile_information_form = UpdateProfileInformationForm.new(params.permit(:name, :email))

    return render partial: 'settings/profile/update_profile_information_form', status: :unprocessable_entity if @update_profile_information_form.invalid?

    @update_profile_information_form.update

    redirect_back_or_to profile_edit_path, flash: { status: 'profile-updated' }
  end

  def destroy
    @delete_user_form = DeleteUserForm.new(params.permit(:password))

    return turbo_stream if @delete_user_form.invalid?

    user = Current.auth.user

    Current.auth.logout

    user.delete

    reset_session

    redirect_to '/'
  end
end
