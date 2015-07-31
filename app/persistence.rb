require "sequel"
require "bcrypt"
require "securerandom"

Sequel.postgres ENV["TODO_DATABASE"]

module Slug
  def create_slug
    SecureRandom.urlsafe_base64 9
  end
end

class Activity < Sequel::Model
  extend Slug

  plugin :validation_helpers

  set_allowed_columns :description, :url_slug

  many_to_one :account

  def validate
    super
    validates_min_length 1,  :description
    validates_max_length 80, :description
    validates_unique [:description, :account_id]
  end
end

class Account < Sequel::Model
  extend Slug

  plugin :validation_helpers

  set_allowed_columns :name, :url_slug, :password_hash

  one_to_many :activity

  def validate
    super
    validates_min_length 4,  :name
    validates_max_length 24, :name
    validates_unique         :name
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
