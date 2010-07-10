Feature: Sign in

  Scenario: Sign in with a valid user
    Given a user exists with a email of "bob@example.com"
    When I am on the homepage
    And I fill in "E-mail" with "bob@example.com"
    And I fill in "Password" with "test"
    And I press "Sign In"
    Then I should be signed in

  Scenario: sign in with a valid user, but invalid password
    Given a user exists with a email of "bob@example.com"
    When I am on the homepage
    And I fill in "E-mail" with "bob@example.com"
    And I fill in "Password" with "nope"
    And I press "Sign In"
    Then I should not be signed in

  Scenario: Sign in with an invalid user
    When I am on the homepage
    And I fill in "E-mail" with "bob@example.com"
    And I fill in "Password" with "test"
    And I press "Sign In"
    Then I should not be signed in
