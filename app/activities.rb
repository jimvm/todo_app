require 'sequel'

Sequel.postgres ENV["TODO_DATABASE"]

class Activity < Sequel::Model
  plugin :validation_helpers

  set_allowed_columns :description, :url_slug

  many_to_one :account

  def validate
    super
    validates_min_length 1,  :description
    validates_max_length 80, :description
    validates_unique [:description, :account_id]
  end

  def self.create_slug
    Time.now.tv_sec.to_s(16)
  end
end
