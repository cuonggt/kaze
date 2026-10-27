class SessionGuard
  attr_reader :name
  attr_reader :last_attempted
  attr_reader :via_remember
  attr_reader :remember_duration
  attr_reader :session
  attr_reader :cookies
  attr_reader :logged_out
  attr_reader :recall_attempted
  attr_reader :user

  def initialize(name:, session:, cookies: nil)
    @name = name
    @session = session
    @cookies = cookies
    @via_remember = false
    @remember_duration = 576000
    @logged_out = false
    @recall_attempted = false
  end

  def get_user
    return nil if @logged_out

    return @user unless @user.nil?

    id = @session[get_name]

    @user = User.find_by(id: id) unless id.nil?

    if @user.nil?
      @user = user_from_recaller

      update_session(@user.id) if @user
    end

    @user
  end

  def attempt(credentials = {}, remember = false)
    user = validate(credentials)

    return false if user.nil?

    login(user, remember)

    true
  end

  # Checks credentials and returns the user without starting a session. The two
  # factor challenge needs this: a correct password is not enough to be logged
  # in when a second factor is required.
  def validate(credentials = {})
    @last_attempted = User.authenticate_by(credentials)
  end

  def login(user, remember = false)
    update_session(user.id)

    if remember
      ensure_remember_token_is_set(user)
      create_recaller_cookie(user)
    end

    set_user(user)
  end

  def logout
    user = get_user

    clear_user_data_from_storage

    cycle_remember_token(user) unless @user.nil? || user.remember_token.blank?

    @user = nil

    @logged_out = true
  end

  def set_user(user)
    @user = user
    @logged_out = false
  end

  def check?
    !get_user.nil?
  end

  private

  def user_from_recaller
    _recaller = recaller

    return nil if _recaller.nil? || !_recaller.valid? || @recall_attempted

    @recall_attempted = true

    user = User.find_by(id: _recaller.id, remember_token: _recaller.token)

    @via_remember = true unless user.nil?

    user
  end

  def recaller
    return nil if @cookies.nil?

    _recaller = @cookies.signed[get_recaller_name]

    _recaller ? Recaller.new(_recaller) : nil
  end

  def update_session(id)
    @session[get_name] = id
  end

  def ensure_remember_token_is_set(user)
    cycle_remember_token(user) if user.remember_token.blank?
  end

  def create_recaller_cookie(user)
    @cookies.signed[get_recaller_name] = {
      value: "#{user.id}|#{user.remember_token}|#{user.password_digest}",
      expires: @remember_duration.minutes.from_now
    }
  end

  def clear_user_data_from_storage
    @session.delete(get_name)
    @cookies.delete(get_recaller_name) unless @cookies.nil?
  end

  def cycle_remember_token(user)
    user.update(remember_token: SecureRandom.alphanumeric(60))
  end

  def get_name
    "login_#{@name}_#{Digest::SHA1.hexdigest(self.class.name)}".to_sym
  end

  def get_recaller_name
    "remember_#{@name}_#{Digest::SHA1.hexdigest(self.class.name)}".to_sym
  end
end

class Recaller
  attr_reader :recaller

  def initialize(recaller)
    @recaller = recaller.split('|')
  end

  def id
    @recaller[0]
  end

  def token
    @recaller[1]
  end

  def valid?
    @recaller.length >= 3 && @recaller[0].present? && @recaller[1].present?
  end
end
