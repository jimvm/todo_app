require 'sequel'

Sequel.postgres ENV["TODO_DATABASE"]

class Account < Sequel::Model
  plugin :validation_helpers

  set_allowed_columns :name

  def validate
    super
    validates_min_length 4,  :name
    validates_max_length 24, :name
    validates_unique         :name
  end
end
