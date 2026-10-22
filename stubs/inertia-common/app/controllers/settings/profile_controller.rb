class Settings::ProfileController < ApplicationController
  skip_ensure_email_is_verified

  def edit
    render inertia: 'Settings/Profile', props: {
      mustVerifyEmail: User.include?(MustVerifyEmail),
      status: flash[:status]
    }
  end

  def update
    form = UpdateProfileInformationForm.new(params.permit(:name, :email))

    return redirect_to profile_edit_path, inertia: { errors: form.error_messages } if form.invalid?

    form.update

    redirect_to profile_edit_path
  end

  def destroy
    form = DeleteUserForm.new(params.permit(:password))

    return redirect_back_or_to profile_edit_path, inertia: { errors: form.error_messages } if form.invalid?

    user = Current.auth.user

    Current.auth.logout

    user.delete

    reset_session

    redirect_to '/'
  end
end
