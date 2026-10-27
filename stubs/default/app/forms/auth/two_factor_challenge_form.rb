class Auth::TwoFactorChallengeForm < ApplicationForm
  attr_accessor :code, :recovery_code

  validate :code_or_recovery_code_present

  # A recovery code is offered as the way in when the authenticator is not to
  # hand, so whichever was filled in is the one that gets checked.
  def authenticate(user)
    return if invalid?

    if recovery_code.present?
      errors.add(:recovery_code, message: 'That recovery code is not valid.') unless user.consume_two_factor_recovery_code(recovery_code)
    else
      errors.add(:code, message: 'That code is not valid.') unless user.verify_two_factor_code(code)
    end
  end

  private
    def code_or_recovery_code_present
      return if code.present? || recovery_code.present?

      errors.add(:code, message: 'Enter the code from your authenticator app, or a recovery code.')
    end
end
