Feature: Managing an account
  A person that wants to track their activities
  should be able to update an account and delete it.

  Scenario: Creating an Account
    Given no accounts exists
    When an Admin creates an Account
    Then an account should exist

  Scenario: An unauthorized person can't see the Account
    Given an account named "aperson" exists
    When someone unauthorized visits the "aperson" account page
    Then the response code should be 401
    And the response body should be empty

  Scenario: An authorized person can't see someone else's Account
    Given an account named "aperson" exists
    When someone authorized visits the "aperson" account page
    Then the response code should be 403
    And the response body should be empty

  Scenario: An authorized person can see their Account
    Given an account named "aperson" exists
    When "aperson" visits their account page
    Then the response code should be 200
    And the HAL/JSON response should be:
    """
    { "_links": {
      "self": { "href": "http://localhost:8080/accounts/fake_slug" }
      },
      "name": "aperson"}
    """
