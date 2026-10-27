class User < ApplicationRecord
  include CanResetPassword
  include TwoFactorAuthenticatable
  # include MustVerifyEmail

  has_secure_password

  normalizes :email, with: ->(email) { email.strip.downcase }

  generates_token_for :password_reset, expires_in: 60.minutes do
    password_salt&.last(10)
  end
end
