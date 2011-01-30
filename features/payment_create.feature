Feature: Create a payment

  Background:
    Given I am signed in
    And I am on the payments page

  Scenario: Create a payment successfully
    When I fill in "Item" with "5.50 on lunch"
    And I press "Add"
    Then I should see a payment for 5.50 on "lunch" from "Today"

  Scenario: Create a payment unsuccessfully
    When I press "Add"
    Then I should not see any payments
