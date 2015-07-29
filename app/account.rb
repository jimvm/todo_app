require 'sequel'
require 'bcrypt'

Sequel.postgres ENV["TODO_DATABASE"]

class Account < Sequel::Model
  plugin :validation_helpers

  set_allowed_columns :name, :url_slug, :password_hash

  one_to_many :activity

  def validate
    super
    validates_min_length 4,  :name
    validates_max_length 24, :name
    validates_unique         :name
  end

  def self.create_slug
    Time.now.tv_sec.to_s(16)
  end

  def self.create_password_hash(password)
    BCrypt::Password.create password
  end

  def self.password(password_hash)
    BCrypt::Password.new password_hash
  end

  def self.verify(username:, password:)
    account = Account.find name: username

    if account
      account_password = Account.password account.password_hash

      account_password == password
    else
      false
    end
  end
end
