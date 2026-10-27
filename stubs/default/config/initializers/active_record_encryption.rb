# Active Record Encryption needs three keys, and a generated application has
# none. Deriving them from secret_key_base means encrypted attributes work the
# moment the application boots, without a second set of secrets to manage.
#
# The consequence is that rotating secret_key_base makes existing ciphertext
# unreadable. To manage the keys separately instead, run
# `bin/rails db:encryption:init` and move them into your credentials.
Rails.application.configure do
  generator = ActiveSupport::KeyGenerator.new(
    Rails.application.secret_key_base,
    hash_digest_class: OpenSSL::Digest::SHA256
  )

  config.active_record.encryption.primary_key =
    generator.generate_key('active_record_encryption_primary_key', 32)
  config.active_record.encryption.deterministic_key =
    generator.generate_key('active_record_encryption_deterministic_key', 32)
  config.active_record.encryption.key_derivation_salt =
    generator.generate_key('active_record_encryption_key_derivation_salt', 32)
end
