# The gap between a correct password and a completed login. The user is not
# logged in while this is pending -- their id is held in the session and nothing
# else -- so an abandoned challenge grants nothing.
class TwoFactorChallenge
  EXPIRES_IN = 5.minutes

  USER_KEY = :two_factor_challenge_user_id
  REMEMBER_KEY = :two_factor_challenge_remember
  STARTED_KEY = :two_factor_challenge_started_at

  def initialize(session)
    @session = session
  end

  def start(user, remember: false)
    @session[USER_KEY] = user.id
    @session[REMEMBER_KEY] = remember
    @session[STARTED_KEY] = Time.current.to_i
  end

  def pending?
    !user.nil?
  end

  def user
    return nil if @session[USER_KEY].nil?

    if expired?
      clear
      return nil
    end

    @user ||= User.find_by(id: @session[USER_KEY])
  end

  def remember?
    @session[REMEMBER_KEY].present?
  end

  def clear
    @session.delete(USER_KEY)
    @session.delete(REMEMBER_KEY)
    @session.delete(STARTED_KEY)
    @user = nil
  end

  private
    # A challenge left open is a password already given, so it should not wait
    # around indefinitely for the second factor.
    def expired?
      started_at = @session[STARTED_KEY]

      started_at.nil? || Time.zone.at(started_at.to_i) < EXPIRES_IN.ago
    end
end
