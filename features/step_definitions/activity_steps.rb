require 'httparty'
require_relative '../../app/activities'

Given(/^an activity called "([^"]*)" exists$/) do |name|
  ActivityStore.transaction { ActivityStore[name] = Activity.new(name) }
end

When(/^I request GET "([^"]*)"$/) do |url|
  @response = HTTParty.get "http://localhost:8080#{url}", headers: {"Accept" => "application/hal+json"}
end

Then(/^the HAL\/JSON response should be:$/) do |expected_hal_json|
  expect(JSON.parse(@response.body)).to eq JSON.parse(expected_hal_json)
end

When(/^I request DELETE "([^"]*)"$/) do |url|
  @response = HTTParty.delete "http://localhost:8080#{url}"
end

Then(/^the response code should be (\d+)$/) do |response_code|
  expect(@response.code.to_s).to eq response_code
end

Then(/^the "([^"]*)" activity should be gone$/) do |name|
  @response = HTTParty.get "http://localhost:8080/activities/#{name}", headers: {"Accept" => "application/hal+json"}
  expect(@response.code).to eq 404
end

Given(/^an activity called "([^"]*)" doesn't exist$/) do |name|
  ActivityStore.transaction { ActivityStore.delete name }
  @response = HTTParty.get "http://localhost:8080/activities/#{name}"
  expect(@response.code).to eq 404
end

When(/^I request POST "([^"]*)" with:$/) do |url, json|
  @response = HTTParty.post "http://localhost:8080#{url}", body: "#{json}", headers: {"Content-Type" => "application/json"}
end

Then(/^the "([^"]*)" activity should exist$/) do |name|
  @response = HTTParty.get "http://localhost:8080/activities/#{name}"
  expect(@response.code).to eq 200
end

When(/^I request PUT "([^"]*)" with:$/) do |url, json|
  @response = HTTParty.put "http://localhost:8080#{url}", body: "#{json}", headers: {"Content-Type" => "application/json"}
end
