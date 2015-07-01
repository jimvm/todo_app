require 'webmachine'
require 'roar/decorator'
require 'roar/json/hal'

class Activity
  def initialize(name)
    @name = name
  end

  attr_reader :name
end

class ActivityDecorator < Roar::Decorator
  include Roar::JSON::HAL

  link :self do
    "http://localhost:8080/activities/#{represented.name}"
  end
end

class ActivityResource < Webmachine::Resource
  def allowed_methods
    ["GET"]
  end

  def content_types_provided
    [["application/hal+json", :to_json]]
  end

  def to_json
    ActivityDecorator.new(Activity.new(name)).to_json
  end

  private
    def name
      request.path_info[:name]
    end
end

Webmachine.application.routes do
  add ["activities", :name], ActivityResource
end
