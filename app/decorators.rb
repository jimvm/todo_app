require "roar/decorator"
require "roar/json/hal"

class ActivityDecorator < Roar::Decorator
  include Roar::JSON::HAL

  link :self do
    "http://localhost:8080/#{represented.account.url_slug}/activities/#{represented.url_slug}"
  end

  link :up do
    "http://localhost:8080/#{represented.account.url_slug}/"
  end

  property :description
end

class AccountDecorator < Roar::Decorator
  include Roar::JSON::HAL

  link :self do
    "http://localhost:8080/#{represented.url_slug}"
  end

  property :name

  collection :activity, as: :activities, extend: ActivityDecorator, embedded: true
end

class AccountsDecorator < Roar::Decorator
  include Roar::JSON::HAL

  link :self do
    "http://localhost:8080/"
  end

  collection :all, as: :accounts, extend: AccountDecorator, embedded: true
end
