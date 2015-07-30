require_relative '../../app/persistence'

Given(/^no accounts exists$/) do
  expect(Account.all).to be_empty
end

When(/^an Admin creates an Account$/) do
  Account.create name: "somename"
end

Then(/^an account should exist$/) do
  expect(Account.all).to_not be_empty
end

Given(/^an account named "([^"]*)" exists$/) do |name|
  Account.create name: name, url_slug: "fake_person", password_hash: Account.create_password_hash('test')
end

When(/^someone unauthorized visits the "([^"]*)" account page$/) do |name|
  account = Account.find name: name

  @response = HTTParty.get "http://localhost:8080/accounts/#{account.url_slug}",
    basic_auth: {:username => "another_person", password: "wrong"}
end

When(/^someone authorized visits the "([^"]*)" account page$/) do |name|
  account = Account.find name: name

  Account.create name: "someoneelse", url_slug: "another_fake_slug", password_hash: Account.create_password_hash('test')
  dif_account = Account.find name: "someoneelse"

  @response = HTTParty.get "http://localhost:8080/accounts/#{account.url_slug}",
    basic_auth: {:username => dif_account.name, password: "test"}
end

When(/^"([^"]*)" visits their account page$/) do |name|
  account = Account.find name: name

  @response = HTTParty.get "http://localhost:8080/accounts/#{account.url_slug}",
    basic_auth: {:username => account.name, password: "test"}
end

Then(/^the response body should be empty$/) do
  expect(@response.body).to be_empty
end
