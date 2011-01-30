Feature: Sign in

  Background:
    Given a user exists with a email of "bob@example.com"
    And I am on the sign in page

  Scenario: User signs in successfully
    When I fill in "E-mail" with "bob@example.com"
    And I fill in "Password" with "test"
    And I press "Sign In"
    Then I should be signed in

  Scenario: User enters the wrong password
    When I fill in "E-mail" with "bob@example.com"
    And I fill in "Password" with "nope"
    And I press "Sign In"
    Then I should be signed out

  Scenario: User is not signed up
    When I fill in "E-mail" with "sue@example.com"
    And I fill in "Password" with "test"
    And I press "Sign In"
    Then I should be signed out
