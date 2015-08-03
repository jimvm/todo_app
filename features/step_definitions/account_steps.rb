Given(/^no accounts exists$/) do
  delete_accounts
end

When(/^an admin creates an account$/) do
  create_account
end

Then(/^an account should exist$/) do
  expect(accounts).to_not be_empty
end

Given(/^an account exists$/) do
  create_account
end

When(/^someone unauthorized visits an account page$/) do
  get_account visitor: "unauth"
end

When(/^someone authorized visits another account page$/) do
  create_account name: "otherperson", url_slug: "fake_person2"

  get_account visitor: "otherperson"
end

When(/I visit my account$/) do
  get_account visitor: "aperson"
end

Then(/^the response body should be empty$/) do
  expect(response.body).to be_empty
end

World(AccountHelpers)
