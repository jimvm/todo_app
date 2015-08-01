require "httparty"
require_relative "../../app/persistence"

module AccountHelpers
  def create_account(name:"aperson", url_slug:"fake_person")
    Account.create name: name,
                   url_slug: url_slug,
                   password_hash: Account.create_password_hash("test")
  end

  def delete_accounts
    Account.each {|account| account.delete}
  end

  def get_account(visitor:)
    @response = HTTParty.get "http://localhost:8080/accounts/fake_person",
      basic_auth: {:username => visitor, password: "test"}
  end

  def accounts
    Account.all
  end

  attr_reader :response
end

module ActivityHelpers
  def get_activity
    @response = HTTParty.get activity_url, headers: {"Accept" => "application/hal+json"}
  end

  def delete_activity
    @response = HTTParty.delete activity_url
  end

  def post_activity(json)
    @response = HTTParty.post activities_url, body: json,
      headers: {"Content-Type" => "application/json"}
  end

  def update_activity(json)
    @response = HTTParty.put activity_url, body: json,
      headers: {"Content-Type" => "application/json"}
  end

  def response_code
    response.code.to_s
  end

  def create_activity
    Activity.create description: "something", url_slug: "fake_slug"
  end

  def delete_activities
    Activity.each {|activity| activity.delete }
  end

  def activity
    Activity.find description: "something"
  end

  def created_activity
    Activity.find description: "nothing"
  end

  def updated_activity
    Activity.find description: "something-else"
  end

  def activities_url
    "http://localhost:8080/accounts/fake_person/activities/"
  end

  def activity_url
    "http://localhost:8080/accounts/fake_person/activities/fake_slug"
  end

  attr_reader :response
end
