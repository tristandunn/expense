Feature: Settings

  Scenario: Setting a custom time zone
    Given the date is "2010-01-02 06:00:00 +0000"
    Given the following payments exist:
      | user                   | item  | cost  | created_at          |
      | email: bob@example.com | lunch | 10.75 | 2010-01-02 00:00:00 |
      | email: bob@example.com | drink |  1.35 | 2010-01-02 00:00:00 |
    And I sign in as "bob@example.com / test"
    When I am on the payments page
    Then I should see a payment for 10.75 on "lunch" from "Today"
    And I should see a payment for 1.35 on "drink" from "Today"
    When I follow "Settings"
    And I select "(GMT-05:00) Eastern Time (US & Canada)" from "Time Zone"
    And I press "Save Settings"
    Then I should be on the home page
    And I should see a payment for 10.75 on "lunch" from "Yesterday"
    And I should see a payment for 1.35 on "drink" from "Yesterday"
