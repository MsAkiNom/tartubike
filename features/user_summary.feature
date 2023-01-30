Feature: History
  As a user
  I want to access my ride history and statistics 
  So that I can track my activities and double-check the charged fees.

Scenario:  View summary of the user usage
    Given the following users exist
    | name | username | password | dateofbirth |    email      | creditcard |
    | Ramil| ramil    | bambum32 | 10.05.2020 | ramil@gmail.com| 1234324324322432|
    | Bumif| baerm    | bsdfbum32 | 13.05.2020 | rmil@gmail.com| 3423423423422432|
    And I click on login button
    And I want to login to the account with username "ramil" and password "bambum32"
    And I write my credentials
    When I click a login submit button
    When I click on UserUsage
    Then I should see an estimate of the total kilometres ridden, the CO2 saved, and the calories burned.

Scenario:  View Ride history
Given the following users exist
    | name | username | password | dateofbirth |    email      | creditcard |
    | Ramil| ramil    | bambum32 | 10.05.2020 | ramil@gmail.com| 1234324324322432|
    | Bumif| baerm    | bsdfbum32 | 13.05.2020 | rmil@gmail.com| 3423423423422432|
    And I click on login button
    And I want to login to the account with username "ramil" and password "bambum32"
    And I write my credentials
    When I click a login submit button
    When I click on RideHistory
    Then I should see a history of the rides made, including date and time, duration of the ride, starting and endpoint
    
Scenario:  View invoice history
Given the following users exist
    | name | username | password | dateofbirth |    email      | creditcard |
    | Ramil| ramil    | bambum32 | 10.05.2020 | ramil@gmail.com| 1234324324322432|
    | Bumif| baerm    | bsdfbum32 | 13.05.2020 | rmil@gmail.com| 3423423423422432|
    And I click on login button
    And I want to login to the account with username "ramil" and password "bambum32"
    And I write my credentials
    When I click a login submit button
    When I click on InvoiceHistory
    Then I should see a history of invoices along with invoice date
    