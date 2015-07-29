require 'roar/decorator'
require 'roar/json/hal'

class ActivityDecorator < Roar::Decorator
  include Roar::JSON::HAL

  link :self do
    "http://localhost:8080/activities/#{represented.url_slug}"
  end

  property :description
end

class AccountDecorator < Roar::Decorator
  include Roar::JSON::HAL

  link :self do
    "http://localhost:8080/accounts/#{represented.url_slug}"
  end

  property :name

  collection :activity, as: :activities, extend: ActivityDecorator, embedded: true
end

class ActivitiesDecorator < Roar::Decorator
  include Roar::JSON::HAL

  link :self do
    "http://localhost:8080/activities"
  end

  collection :all, as: :activities, extend: ActivityDecorator, embedded: true
end
