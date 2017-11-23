Feature: Select payment schemes
  As an automated system (PSMS)
  Such that our customers can select the payment schemes as hourly or real-time payment
  I want to select the payment schemes as hourly pay or real-time pay
  Scenario Outline: Selecting payment schemes via mobile phone
    Given the following two payment schemes
          | payment_schemes  |
          | hourly           |
          | real-time        |
    And I want to select the "<payment_schemes>"
    And I open the PSMS webpage
    And I select the available parking space for use
    When two  payment schemes are displayed
    Then I should be able to select one of the two payment schemes  


Feature: Submit start and end-time of parking space
  As an automated system (PSMS)
  Such that our customers can submit the start and end time of the parking space
  I want to submit the start and end of parking space in use
  Scenario Outline: Selecting start and end time via mobile phone
    Given the following option for submiting the start or end time
          |timer_type       |
          |start_timer      |
          |end_timer        |
  And I want to submit  the "<timer_type>"
  And I open the PSMS webpage
  When I select the available parking space and payment scheme
  Then I should be able to submit the start time for the selected parking space
  When I finish using the parking space
  Then I should be able to submit the end time for the in-use parking space
  

  Feature: Block the in-use parking space
  As an automated system (PSMS)
  Such that our customers cannot see the parking space when it is in use
  I want to make sure once the start time is submitted, the parking space is blocked as in-use and not displayed as available
  Scenario Outline: Blocking parking space via mobile phone
    Given the following parking spaces are available for given "<destination_address>"
          | location    | Zone  | price_per_hour | price_per_5mins |    zone_type   |
          | Vanemuise 4 | ZoneA |       2        |       0.16      |       paid     |
          | Vaksali 6   | ZoneB |       1        |       0.08      |       paid     |
          | Umera 1     | ZoneL |       0        |       0.00      | free_with_time |
          | Umera 2     | ZoneU |       0        |       0.00      |       free     |
    And I want to select the "<location>" for the parking space
    And I select the <payment_schemes> and start the timer for parking space
    When I uses the "<location>" parking space
    Then I should not be able to see the "<location>" in the list of available parking space for destination "<destination_address>"


  Feature: Notify the end time 
  As an automated system (PSMS)
  Such that our hourly payment customers receive end time notification 10 minutes before the end tinme
  I want to receive the end time notification 10 before the actual end time for which payment has been done
  Scenario Outline: Receiving end-time notification via mobile phone
    Given the parking space "<location>" in use
    And I am using the hourly payment scheme
    And I entered the end time as "<end_time>"
    When the current time is "<end_time - 10 min>"
    Then I should receive a notification that your in-use parking space time for <"location"> is ending in 10 minutes

  Feature: Provide extend-time option 
  As an automated system (PSMS)
  Such that our hourly payment customers receive extend option 10 minutes before the end time
  I want to receive extend time option 10 before the actual end time for which payment has been done
  Scenario Outline: Receiving time extension option to extend in use time via mobile phone
    Given the parking space "<location>" in use and given the following option to extend the in-use parking time
          | Decision_to_extend    | 
          | Yes                   |
          | No                    |
    And I receive the notification  when current time is "<end_time - 10 min>" "Do you want to extend the time?"
    And I select "Yes" to extend the in-use parking time
    And I enter the "<new end time>" 
    And I submit the "<new end time>" 
    Then I should be able to continue to use the current in-use parking space till the "<new end time>"


  Feature: Advertise about to be available parking space 
  As an automated system (PSMS)
  Such that customers rejects extension of end time option and parking space is about to be available for use
  I want to display the parking space before the 2 minutes of the current end time as advertised as available for use
  Scenario Outline: Advertising parking space as available via mobile phone
    Given the parking space "<location>" in use and given the following option to extend the in-use parking time
          | Decision_to_extend    | 
          | Yes                   |
          | No                    |
    And I receive the notification  when current time is "<end_time - 10 min>" "Do you want to extend the time?"
    And I select "No" to end the in-use parking time at "<end_time>"
    And I go to the PSMS' home web page
    And I enter the destination address "<destination_address>", start time and end time in the PSMS system
    When I submit the a search for parking spaces
    Then I should be able to see the current in-use parking space is displayed in the list of available spaces


