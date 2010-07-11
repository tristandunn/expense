Feature: Sign in

  Scenario: User signs in successfully
    Given a user exists with a email of "bob@example.com"
    When I go to the sign in page
    And I fill in "E-mail" with "bob@example.com"
    And I fill in "Password" with "test"
    And I press "Sign In"
    Then I should be signed in

  Scenario: User enters the wrong password
    Given a user exists with a email of "bob@example.com"
    When I go to the sign in page
    And I fill in "E-mail" with "bob@example.com"
    And I fill in "Password" with "nope"
    And I press "Sign In"
    Then I should be signed out

  Scenario: User is not signed up
    When I go to the sign in page
    And I fill in "E-mail" with "bob@example.com"
    And I fill in "Password" with "test"
    And I press "Sign In"
    Then I should be signed out
