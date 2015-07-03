require 'roar/decorator'
require 'roar/json/hal'

class ActivityDecorator < Roar::Decorator
  include Roar::JSON::HAL

  link :self do
    "http://localhost:8080/activities/#{represented.name}"
  end

  property :name
end

class ActivitiesDecorator < Roar::Decorator
  include Roar::JSON::HAL

  link :self do
    "http://localhost:8080/activities"
  end

  collection :activities, extend: ActivityDecorator, embedded: true
end
