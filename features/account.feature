Feature: Managing an account
  A person that wants to track their activities
  should be able to update an account and delete it.

  Scenario: Creating an Account
    Given no accounts exists
    When an Admin creates an Account
    Then an account should exist
