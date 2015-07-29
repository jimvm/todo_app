Feature: Managing activities
  A person that wants to track their day to day tasks
  should be able to manage their activities.

  Scenario: Viewing all activities
    Given an account named "aperson" exists
    And "aperson" has an activity called "something"
    When "aperson" visits their account page
    Then the response code should be 200
    And the HAL/JSON response should be:
    """
    { "_links": {
    "self": { "href": "http://localhost:8080/accounts/fake_person" }
    },
    "name": "aperson",
    "_embedded": {
      "activities": [
      { "_links": {
          "self": { "href": "http://localhost:8080/activities/fake_slug"}
          },
          "description": "something"
      }
      ]
    }
    }
    """

  Scenario: Viewing a specific activity
    Given an activity called "something" exists
    When I request GET "/activities/fake_slug"
    Then the HAL/JSON response should be:
    """
    { "_links": {
      "self": { "href": "http://localhost:8080/activities/fake_slug" }
      },
      "description": "something"}
    """

  Scenario: Creating an activity
    Given an activity called "nothing" doesn't exist
    When I request POST "/activities" with:
    """
    {"description": "nothing" }
    """
    Then the response code should be 201
    And the "nothing" activity should exist

  Scenario: Updating an activity
    Given an activity called "something" exists
    When I request PUT "/activities/fake_slug" with:
    """
    {"description": "something-else" }
    """
    Then the response code should be 204
    And the "something" activity should be gone
    And the "something-else" activity should exist

  Scenario: Deleting an activity
    Given an activity called "something" exists
    When I request DELETE "/activities/fake_slug"
    Then the response code should be 204
    And the "something" activity should be gone
