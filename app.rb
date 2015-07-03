require 'webmachine'
require 'roar/decorator'
require 'roar/json/hal'
require 'yaml/store'
require 'json'

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

  property :name
end

class Activities
  def activities
    all = roots.inject([]) do |result, name|
      activity = ActivityStore.transaction { ActivityStore[name] }
      result << activity
    end
  end

  private
    def roots
      @roots ||= ActivityStore.transaction { ActivityStore.roots }
    end
end

class ActivitiesDecorator < Roar::Decorator
  include Roar::JSON::HAL

  link :self do
    "http://localhost:8080/activities"
  end

  collection :activities, extend: ActivityDecorator, embedded: true
end

class ActivityResource < Webmachine::Resource
  def allowed_methods
    ["GET", "DELETE", "PUT"]
  end

  def content_types_provided
    [["application/hal+json", :to_json]]
  end

  def content_types_accepted
    [["application/json", :from_json]]
  end

  def resource_exists?
    activity
  end

  def delete_resource
    ActivityStore.transaction { ActivityStore.delete name }
  end

  def to_json
    ActivityDecorator.new(activity).to_json
  end

  private
    def from_json
      new_activity = Activity.new(new_name)

      ActivityStore.transaction do
        ActivityStore.delete name
        ActivityStore[new_name] = new_activity
      end
    end

    def activity
      @activity ||= ActivityStore.transaction { ActivityStore.fetch name }
    rescue PStore::Error
      false
    end

    def name
      request.path_info[:name]
    end

    def new_name
      json = JSON.parse(request.body.to_s)
      json["name"]
    end
end

class ActivitiesResource < Webmachine::Resource
  def allowed_methods
    ["GET", "POST"]
  end

  def content_types_provided
    [["application/hal+json", :to_json]]
  end

  def content_types_accepted
    [["application/json", :from_json]]
  end

  def post_is_create?
    true
  end

  def create_path
    "/activities/#{name}"
  end

  def to_json
    ActivitiesDecorator.new(Activities.new).to_json
  end

  private
    def from_json
      activity = Activity.new(name)
      ActivityStore.transaction { ActivityStore[name] = activity }
    end

    def name
      json = JSON.parse(request.body.to_s)
      json["name"]
    end
end

Webmachine.application.routes do
  add ["activities", :name], ActivityResource
  add ["activities"], ActivitiesResource
end
