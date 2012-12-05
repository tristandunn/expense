Feature: Sign up

  Background:
    Given I am on the sign up page

  Scenario: User signs up successfully
    When I fill in "user_email" with "bob@example.com"
    And I fill in "user_password" with "test"
    And I fill in "user_password_confirmation" with "test"
    And I press "Sign Up"
    Then I should be signed in

  Scenario: User signs up with invalid information
    When I press "Sign Up"
    Then I should be signed out
    And I should see "Email can't be blank"
    And I should see "Password can't be blank"
    And I should see "Password confirmation can't be blank"
