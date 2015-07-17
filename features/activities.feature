Feature: Managing activities
  A person that wants to track their day to day tasks
  should be able to manage their activities.

  Scenario: Viewing all activities
    Given an activity called "something" exists
    When I request GET "/activities"
    Then the response code should be 200
    And the HAL/JSON response should be:
    """
    { "_links": {
    "self": { "href": "http://localhost:8080/activities" }
    },
    "_embedded": {
      "activities": [
      { "_links": {
          "self": { "href": "http://localhost:8080/activities/something"}
          },
          "description": "something"
      }
      ]
    }
    }
    """

  Scenario: Viewing a specific activity
    Given an activity called "something" exists
    When I request GET "/activities/something"
    Then the HAL/JSON response should be:
    """
    { "_links": {
      "self": { "href": "http://localhost:8080/activities/something" }
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
    When I request PUT "/activities/something" with:
    """
    {"description": "something-else" }
    """
    Then the response code should be 204
    And the "something" activity should be gone
    And the "something-else" activity should exist

  Scenario: Deleting an activity
    Given an activity called "something" exists
    When I request DELETE "/activities/something"
    Then the response code should be 204
    And the "something" activity should be gone
