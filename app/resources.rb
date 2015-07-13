require_relative 'decorators'
require_relative 'activities'

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
    Activity.delete name
  end

  def to_json
    ActivityDecorator.new(activity).to_json
  end

  private
    def from_json
      Activity.replace name, new_name
    end

    def activity
      @activity ||= Activity.find name
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
    ActivitiesDecorator.new(Activity).to_json
  end

  private
    def from_json
      Activity.create name
    end

    def name
      json = JSON.parse(request.body.to_s)
      json["name"]
    end
end
