require 'sequel'

Sequel.postgres ENV["TODO_DATABASE"]

class Activity < Sequel::Model
  set_allowed_columns :name
end
