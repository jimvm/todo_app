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
    activity.delete
  end

  def to_json
    ActivityDecorator.new(activity).to_json
  end

  private
    def from_json
      activity.update description: new_description
    end

    def activity
      @activity ||= Activity.find(description: description)
    end

    def description
      request.path_info[:description]
    end

    def new_description
      json = JSON.parse(request.body.to_s)
      json["description"]
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
    "/activities/#{description}"
  end

  def to_json
    ActivitiesDecorator.new(Activity).to_json
  end

  private
    def from_json
      Activity.create description: description
    end

    def description
      json = JSON.parse(request.body.to_s)
      json["description"]
    end
end
