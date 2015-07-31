Feature: Managing an account
  A person that wants to track their activities
  should be able to update an account and delete it.

  Background:
    Given an account exists

  Scenario: Creating an Account
    Given no accounts exists
    When an admin creates an account
    Then an account should exist

  Scenario: An unauthorized person can't see the Account
    When someone unauthorized visits an account page
    Then the response code should be 401
    And the response body should be empty

  Scenario: An authorized person can't see someone else's Account
    When someone authorized visits another account page
    Then the response code should be 403
    And the response body should be empty

  Scenario: An authorized person can see their Account
    When I visit my account
    Then the response code should be 200
    And the HAL/JSON response should be:
    """
    { "_links": {
      "self": { "href": "http://localhost:8080/accounts/fake_person" }
      },
      "name": "aperson",
      "_embedded": { "activities": [] }
    }
    """
