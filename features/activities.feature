Feature: An overview of my activities

  Scenario: Seeing all my activities
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
          "name": "something"
      }
      ]
    }
    }
    """
