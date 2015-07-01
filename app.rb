require 'webmachine'
require 'roar/decorator'
require 'roar/json/hal'
require 'yaml/store'

class Activity
  def initialize(name)
    @name = name
  end

  attr_reader :name
end

ActivityStore = YAML::Store.new("activities.yml")

class ActivityDecorator < Roar::Decorator
  include Roar::JSON::HAL

  link :self do
    "http://localhost:8080/activities/#{represented.name}"
  end
end

class ActivityResource < Webmachine::Resource
  def allowed_methods
    ["GET", "DELETE"]
  end

  def content_types_provided
    [["application/hal+json", :to_json]]
  end

  def resource_exists?
    activity
  end

  def delete_resource
    ActivityStore.transaction { ActivityStore.delete name }
  end

  def to_json
    ActivityDecorator.new(Activity.new(name)).to_json
  end

  private
    def activity
      @activity ||= ActivityStore.transaction { ActivityStore.fetch name }
    rescue PStore::Error
      false
    end

    def name
      request.path_info[:name]
    end
end

Webmachine.application.routes do
  add ["activities", :name], ActivityResource
end
