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
