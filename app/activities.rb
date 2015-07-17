require 'sequel'

Sequel.postgres ENV["TODO_DATABASE"]

class Activity < Sequel::Model
  plugin :validation_helpers

  set_allowed_columns :description

  def validate
    super
    validates_min_length 1,  :description
    validates_max_length 80, :description
    validates_unique         :description
  end
end
