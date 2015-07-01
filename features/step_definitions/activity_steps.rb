require 'httparty'

Given(/^an activity called "([^"]*)" exists$/) do |name|
  ActivityStore.transaction { ActivityStore[name] = Activity.new(name) }
end

When(/^I request GET "([^"]*)"$/) do |url|
  @response = HTTParty.get "http://localhost:8080#{url}", headers: {"Accept" => "application/hal+json"}
end

Then(/^the HAL\/JSON response should be:$/) do |expected_hal_json|
  expect(JSON.parse(@response.body)).to eq JSON.parse(expected_hal_json)
end
