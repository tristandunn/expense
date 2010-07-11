Feature: Create a payment

  Scenario: Create a payment successfully
    Given I am signed in
    When I am on the payments page
    And I fill in "Item" with "5.50 on lunch"
    And I press "Add"
    Then I should see a payment for 5.50 on "lunch" from "Today"

  Scenario: Create a payment unsuccessfully
    Given I am signed in
    When I am on the payments page
    And I press "Add"
    Then I should not see any payments
