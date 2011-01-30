Feature: View payments

  Scenario: Viewing payments
    Given the date is "2010-01-02"
    And the following payments exist:
      | user                   | item   | cost  | created_at |
      | email: bob@example.com | lunch  | 10.75 | 2010-01-02 |
      | email: bob@example.com | drink  |  1.35 | 2010-01-01 |
      | email: sue@example.com | drinks |  2.30 | 2009-12-27 |
    And I sign in as "bob@example.com / test"
    When I am on the payments page
    Then I should see a payment for 10.75 on "lunch" from "Today"
    And I should see a payment for 1.35 on "drink" from "Yesterday"
    And I should not see a payment for 2.30 on "drinks" from "Last Week"

  Scenario: Viewing no payments
    Given I am signed in
    When I am on the payments page
    Then I should not see any payments
    And I should see "No Expenses"
    And I should see "You do not have any expenses, yet. Once you spend some money add it using the field above."
