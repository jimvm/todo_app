Feature: Managing activities
  A person that wants to track their day to day tasks
  should be able to manage their activities.

  Background:
    Given an account has an activity

  Scenario: Viewing all activities
    When I visit my account
    Then the response code should be 200
    And the HAL/JSON response should be:
    """
    { "_links": {
    "self": { "href": "http://localhost:8080/accounts/fake_person1" }
    },
    "name": "aperson",
    "_embedded": {
      "activities": [
      { "_links": {
          "self": { "href": "http://localhost:8080/accounts/fake_person1/activities/fake_slug_01"}
          },
          "description": "something"
      }
      ]
    }
    }
    """

  Scenario: Viewing a specific activity
    When I visit my activity
    Then the HAL/JSON response should be:
    """
    { "_links": {
      "self": { "href": "http://localhost:8080/accounts/fake_person1/activities/fake_slug_01" }
      },
      "description": "something"}
    """

  Scenario: Creating an activity
    Given no activities exist
    When I post an activity with:
    """
    {"description": "nothing" }
    """
    Then the response code should be 201
    And the activity should be created

  Scenario: Updating an activity
    When I update my activity with:
    """
    {"description": "something-else" }
    """
    Then the response code should be 204
    And the activity should be updated

  Scenario: Deleting an activity
    When I delete my activity
    Then the response code should be 204
    And the activity should be gone
