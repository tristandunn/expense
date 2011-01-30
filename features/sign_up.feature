Feature: Sign up

  Background:
    Given I am on the sign up page

  Scenario: User signs up successfully
    When I fill in "E-mail" with "bob@example.com"
    And I fill in "Password" with "test"
    And I fill in "Password Confirmation" with "test"
    And I press "Sign Up"
    Then I should be signed in

  Scenario: User signs up with invalid information
    When I press "Sign Up"
    Then I should be signed out
    And I should see "Email can't be blank"
    And I should see "Password can't be blank"
    And I should see "Password confirmation can't be blank"
