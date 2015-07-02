Feature: Interacting with an activity
  A person that wants to track their day to day tasks
  should be able to manage an activity.

  Scenario: Viewing an activity
    Given an activity called "something" exists
    When I request GET "/activities/something"
    Then the HAL/JSON response should be:
    """
    { "_links": {
      "self": { "href": "http://localhost:8080/activities/something" }
    }}
    """

  Scenario: Deleting an activity
    Given an activity called "something" exists
    When I request DELETE "/activities/something"
    Then the response code should be 204
    And the "something" activity should be gone

  Scenario: Creating an activity
    Given an activity called "nothing" doesn't exist
    When I request POST "/activities" with:
    """
{"name": "nothing" }
    """
    Then the response code should be 201
    And the "nothing" activity should exist
