# Turning two factor off removes a protection, so it asks for the password. A
# stolen session should not be enough to undo it.
class DisableTwoFactorForm < ApplicationForm
  attr_accessor :password

  validates :password, presence: true, current_password: true
end
