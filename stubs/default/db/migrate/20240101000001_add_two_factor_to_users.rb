class AddTwoFactorToUsers < ActiveRecord::Migration
  def self.up
    change_table :users, bulk: true do |table|
      table.text :two_factor_secret
      table.text :two_factor_recovery_codes
      table.timestamp :two_factor_confirmed_at
    end
  end

  def self.down
    change_table :users, bulk: true do |table|
      table.remove :two_factor_secret, :two_factor_recovery_codes, :two_factor_confirmed_at
    end
  end
end
