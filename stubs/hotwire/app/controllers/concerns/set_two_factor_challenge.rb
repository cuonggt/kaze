module SetTwoFactorChallenge
  extend ActiveSupport::Concern

  private
    def two_factor_challenge
      @two_factor_challenge ||= TwoFactorChallenge.new(session)
    end
end
