class Auth::LoginForm < ApplicationForm
  attr_accessor :email, :password, :remember
  attr_reader :user

  validates :email, presence: true, email: true
  validates :password, presence: true

  # Checks the credentials without logging anyone in, so the caller can decide
  # whether a second factor is still owed.
  def authenticate
    return if invalid?

    @user = Current.auth.validate({ email: @email, password: @password })

    errors.add(:email, message: 'These credentials do not match our records.') if @user.nil?
  end
end
