Feature: Interactive search of parking space
  As an automated system (PSMS)
  Such that our customers can search for parking space based on destination address
  I want to view the available parking space closest to the destination on a map
  Scenario Outline: Searching via mobile phone
    Given the following parking spaces are available
          | location    | Zone  | price_per_hour | price_per_5mins |    zone_type   |
          | coord   | ZoneA |       2        |       0.16      |       paid     |
          | Vaksali 6   | ZoneB |       1        |       0.08      |       paid     |
          | Umera 1     | ZoneL |       0        |       0.00      | free_with_time |
          | Umera 2     | ZoneU |       0        |       0.00      |       free     |
    And I want to go to "<destination_address>"
    And I open PSMS' web page
    When I enter the destination address in the PSMS system
    Then  I should see a summary of available parking space around that address presented overlaid over a map 
    And that summary should include information about the price that applies "< price_per_hour>" and "< price_per_5mins>"
    When I enter my intended leaving hour
    Then I should see an estimation of the fee to be paid
