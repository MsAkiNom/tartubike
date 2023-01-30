Feature: Interactive search
  As a user
  Such that I want to rent a bike
  I want to know about the locations of available dock stations and information about them

Scenario: View dock stations
    When I click on station map
    Then I should see a map with the locations of dock stations

Scenario: View bike information of dock stations
    When I click on station map
    Then I should see a number of bike in each stations

Scenario: View nearest stations
    Given I am viewing a station map
    When I click on use my location
    Then I should see the distance from your location to the closest dock
