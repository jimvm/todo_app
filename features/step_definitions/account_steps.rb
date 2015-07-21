require_relative '../../app/account'

Given(/^no accounts exists$/) do
  expect(Account.all).to be_empty
end

When(/^an Admin creates an Account$/) do
  Account.create name: "somename"
end

Then(/^an account should exist$/) do
  expect(Account.all).to_not be_empty
end
