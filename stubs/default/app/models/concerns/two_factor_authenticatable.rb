# Time-based one-time passwords, in the shape Laravel's starter kits use: a
# secret is generated first and only counts as enabled once the user has proved
# they can read codes from it, so nobody can lock themselves out by walking away
# from a half-finished setup.
module TwoFactorAuthenticatable
  extend ActiveSupport::Concern

  RECOVERY_CODE_COUNT = 8

  # A window of one step either side, so a code is still accepted if the user's
  # clock is a little out or they typed it as it was expiring.
  DRIFT = 30

  included do
    encrypts :two_factor_secret
    encrypts :two_factor_recovery_codes
  end

  def two_factor_enabled?
    two_factor_secret.present? && two_factor_confirmed_at.present?
  end

  # A secret exists but has not been confirmed. Setup was started and not
  # finished; the account is not protected yet.
  def two_factor_pending?
    two_factor_secret.present? && two_factor_confirmed_at.nil?
  end

  # Starts setup, replacing anything half-finished from a previous attempt.
  def prepare_two_factor
    update!(
      two_factor_secret: ROTP::Base32.random,
      two_factor_recovery_codes: generate_recovery_codes.to_json,
      two_factor_confirmed_at: nil
    )
  end

  def confirm_two_factor(code)
    return false unless two_factor_pending? && verify_two_factor_code(code)

    update!(two_factor_confirmed_at: Time.current)

    true
  end

  def disable_two_factor
    update!(two_factor_secret: nil, two_factor_recovery_codes: nil, two_factor_confirmed_at: nil)
  end

  def verify_two_factor_code(code)
    return false if two_factor_secret.blank? || code.blank?

    totp.verify(code.to_s.strip, drift_behind: DRIFT, drift_ahead: DRIFT).present?
  end

  # Recovery codes are single use. Returns false without consuming anything if
  # the code is not one of ours.
  def consume_two_factor_recovery_code(code)
    return false if code.blank?

    remaining = two_factor_recovery_codes_list
    index = remaining.index(code.to_s.strip)

    return false if index.nil?

    remaining.delete_at(index)
    update!(two_factor_recovery_codes: remaining.to_json)

    true
  end

  def two_factor_recovery_codes_list
    return [] if two_factor_recovery_codes.blank?

    JSON.parse(two_factor_recovery_codes)
  rescue JSON::ParserError
    []
  end

  def regenerate_two_factor_recovery_codes
    update!(two_factor_recovery_codes: generate_recovery_codes.to_json)
  end

  # What the authenticator app scans. The issuer is what the user will see
  # listed in their app, so it is the application's name rather than a URL.
  def two_factor_provisioning_uri(issuer: nil)
    return nil if two_factor_secret.blank?

    totp(issuer: issuer).provisioning_uri(email)
  end

  def two_factor_qr_code_svg(issuer: nil)
    uri = two_factor_provisioning_uri(issuer: issuer)

    return nil if uri.nil?

    RQRCode::QRCode.new(uri).as_svg(viewbox: true, use_path: true, module_size: 4)
  end

  private
    def totp(issuer: nil)
      ROTP::TOTP.new(two_factor_secret, issuer: issuer || default_two_factor_issuer)
    end

    def default_two_factor_issuer
      Rails.application.class.module_parent_name
    end

    def generate_recovery_codes
      Array.new(RECOVERY_CODE_COUNT) { "#{SecureRandom.alphanumeric(10)}-#{SecureRandom.alphanumeric(10)}".downcase }
    end
end
