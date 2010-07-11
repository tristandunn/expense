Feature: Sign out

  Scenario: User signs out
    Given a user exists with a email of "bob@example.com"
    When I sign in as "bob@example.com / test"
    Then I should be signed in
    When I sign out
    Then I should be signed out
