require_relative "decorators"
require_relative "persistence"
require "json"

class AccountsResource < Webmachine::Resource
  def allowed_methods
    ["GET"]
  end

  def content_types_provided
    [["application/hal+json", :to_json]]
  end

  def resource_exists?
    true
  end

  def to_json
    AccountsDecorator.new(Account).to_json
  end
end

class AccountResource < Webmachine::Resource
  include Webmachine::Resource::Authentication

  def allowed_methods
    ["GET"]
  end

  def resource_exists?
    account
  end

  def content_types_provided
    [["application/hal+json", :to_json]]
  end

  def to_json
    AccountDecorator.new(account).to_json
  end

  def is_authorized?(authorization_header)
    basic_auth(authorization_header, "Account") do |username, password|
      verified = Account.verify username: username, password: password

      @authorized_account = Account.find name: username
    end
  end

  def forbidden?
    true if account != authorized_account
  end

  private
    def account
      @account ||= Account.find url_slug: account_slug
    end

    def account_slug
      request.path_info[:account_slug]
    end

    attr_reader :authorized_account
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
      @activity ||= Activity.find(url_slug: activity_slug)
    end

    def activity_slug
      request.path_info[:activity_slug]
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
    "/#{account_slug}/activities/#{activity_slug}"
  end

  def to_json
    ActivitiesDecorator.new(Activity).to_json
  end

  private
    def from_json
      account.add_activity Activity.new description: description, url_slug: activity_slug
    end

    def description
      json = JSON.parse(request.body.to_s)
      json["description"]
    end

    def activity_slug
      @activity_slug ||= Activity.create_slug
    end

    def account_slug
      @account_slug ||= request.path_info[:account_slug]
    end

    def account
      @account ||= Account.find url_slug: account_slug
    end
end
