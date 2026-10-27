class ConfirmTwoFactorForm < ApplicationForm
  attr_accessor :code

  validates :code, presence: true
end
