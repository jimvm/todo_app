require "json"

When(/^I visit my activity$/) do
  get_activity
end

Then(/^the HAL\/JSON response should be:$/) do |expected_hal_json|
  expect(JSON.parse(response.body)).to eq JSON.parse(expected_hal_json)
end

When(/^I delete my activity$/) do
  delete_activity
end

Then(/^the response code should be (\d+)$/) do |code|
  expect(response_code).to eq code
end

Then(/^the activity should be gone$/) do
  expect(activity).to be_nil
end

Then(/^the activity should be updated$/) do
  expect(activity).to be_nil

  expect(updated_activity).to exist
end

Given(/^no activities exist$/) do
  delete_activities
end

When(/^I post an activity with:$/) do |json|
  post_activity json
end

Then(/^the activity should be created$/) do
  expect(created_activity).to exist
end

When(/^I update my activity with:$/) do |json|
  update_activity json
end

Given(/^an account has an activity$/) do
  create_account.add_activity create_activity
end

World(ActivityHelpers)
