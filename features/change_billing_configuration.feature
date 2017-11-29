Feature: Change RealTime billing configuration
  As an automated system (PSMS)
  Such that our customers can change their option of billing
  I want to pay at the end of each month
  Scenario Outline: changing configuration
    Given the following users are in the system
          | username   | password	   |
          | bejo074    | parool        |
    And I want to log into my dashboard
    And I want to change my billing configuration
    And I select my option
    When I summit the booking request
    Then I should be notified with success message