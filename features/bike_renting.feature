Feature: Bike renting
    As a user, I want to rent a bike, so that I can use it.

  Scenario: Rent a bike with a confirmation
    Given the following dock exists
      |   name     | capacity | latitude | longitude |
      | Narva 22   |   25     |   30.50  |   40.50   |
      | Raatuse 22 |   30     |   31.20  |   52.30   |
    Given the following bikes exist in that dock
      |   type  |   status   |
      | electric |  available |
      | classic |  available |
    Given the following users exist
    | name | username | password | dateofbirth |    email      | creditcard |
    | Ramil| ramil    | bambum32 | 10.05.2020 | ramil@gmail.com| 1234324324322432|
    | Bumif| baerm    | bsdfbum32 | 13.05.2020 | rmil@gmail.com| 3423423423422432|
    And I click on login button
    And I want to login to the account with username "ramil" and password "bambum32"
    And I write my credentials
    When I click a login submit button
    Then I should see a confirmation of authenthication
    And I want to select the bike with type "electric"
    And I go to rent the bike page
    And I enter id of the bike
    When I click a rent button
    Then I should see a confirmation message

  Scenario: Rent a booked bike with a confirmation
    Given the following dock exists
      |   name     | capacity | latitude | longitude |
      | Narva 22   |   25     |   30.50  |   40.50   |
      | Raatuse 22 |   30     |   31.20  |   52.30   |
    Given the following bikes exist in that dock
      |   type  |   status   |
      | electric |  available |
      | classic |  available |
    Given the following users exist
    | name | username | password | dateofbirth |    email      | creditcard |
    | Ramil| ramil    | bambum32 | 10.05.2020 | ramil@gmail.com| 1234324324322432|
    | Bumif| baerm    | bsdfbum32 | 13.05.2020 | rmil@gmail.com| 3423423423422432|
    And I click on login button
    And I want to login to the account with username "ramil" and password "bambum32"
    And I write my credentials
    When I click a login submit button
    Then I should see a confirmation of authenthication
    And I want to select the bike with type "electric"
    And I go to book the bike page
    And I enter id of the bike
    When I click a book button
    Then I should see a booking confirmation message
    And I go to rent the bike page
    And I enter id of the bike
    When I click a rent button
    Then I should see a confirmation message

  Scenario: Rent a booked bike with a rejection
    Given the following dock exists
      |   name     | capacity | latitude | longitude |
      | Narva 22   |   25     |   30.50  |   40.50   |
      | Raatuse 22 |   30     |   31.20  |   52.30   |
    Given the following bikes exist in that dock
      |   type  |   status   |
      | electric |  available |
      | classic |  available |
    Given the following users exist
    | name | username | password | dateofbirth |    email      | creditcard |
    | Ramil| ramil    | bambum32 | 10.05.2020 | ramil@gmail.com| 1234324324322432|
    | Bumif| baerm    | bsdfbum32 | 13.05.2020 | rmil@gmail.com| 3423423423422432|
    And I click on login button
    And I want to login to the account with username "ramil" and password "bambum32"
    And I write my credentials
    When I click a login submit button
    Then I should see a confirmation of authenthication
    And I want to select the bike with type "electric"
    And I go to book the bike page
    And I enter id of the bike
    When I click a book button
    Then I should see a booking confirmation message
    And I click on log out button
    And I click on login button
    And I want to login to the account with username "baerm" and password "bsdfbum32"
    And I write my credentials
    When I click a login submit button
    Then I should see a confirmation of authenthication
    And I go to rent the bike page
    And I enter id of the bike
    When I click a rent button
    Then I should see a rejection message

  Scenario: Rent a bike with non-existent id rejection
    Given the following dock exists
      |   name     | capacity | latitude | longitude |
      | Narva 22   |   25     |   30.50  |   40.50   |
      | Raatuse 22 |   30     |   31.20  |   52.30   |
    Given the following bikes exist in that dock
      |   type  |   status   |
      | electric |  available |
      | classic |  available |
    Given the following users exist
    | name | username | password | dateofbirth |    email      | creditcard |
    | Ramil| ramil    | bambum32 | 10.05.2020 | ramil@gmail.com| 1234324324322432|
    | Bumif| baerm    | bsdfbum32 | 13.05.2020 | rmil@gmail.com| 3423423423422432|
    And I click on login button
    And I want to login to the account with username "ramil" and password "bambum32"
    And I write my credentials
    When I click a login submit button
    Then I should see a confirmation of authenthication
    And I want to select the bike with non existent id
    And I go to rent the bike page
    And I enter id of the bike
    When I click a rent button
    Then I should see a rejection message


 Scenario: End the ride with a confirmation
    Given the following dock exists
      |   name     | capacity | latitude | longitude |
      | Narva 22   |   25     |   30.50  |   40.50   |
      | Raatuse 22 |   30     |   31.20  |   52.30   |
    Given the following bikes exist in that dock
      |   type  |   status   |
      | electric |  available |
      | classic |  available |
    Given the following users exist
    | name | username | password | dateofbirth |    email      | creditcard |
    | Ramil| ramil    | bambum32 | 10.05.2020 | ramil@gmail.com| 1234324324322432|
    | Bumif| baerm    | bsdfbum32 | 13.05.2020 | rmil@gmail.com| 3423423423422432|
    And I click on login button
    And I want to login to the account with username "ramil" and password "bambum32"
    And I write my credentials
    When I click a login submit button
    Then I should see a confirmation of authenthication
    Given I rented the bike with type "electric"
    And I go to end the ride page
    And I enter id of the bike
    And I enter id of the dock
    When I click a end button
    Then I should see an ending ride confirmation message

 Scenario: End the ride fail by attempt to return a bike at station with no empty dock
    Given the following users exist
    | name | username | password | dateofbirth |    email      | creditcard |
    | Ramil| ramil    | bambum32 | 10.05.2020 | ramil@gmail.com| 1234324324322432|
    | Bumif| baerm    | bsdfbum32 | 13.05.2020 | rmil@gmail.com| 3423423423422432|
    And I click on login button
    And I want to login to the account with username "ramil" and password "bambum32"
    And I write my credentials
    And I click a login submit button
    Given I rented the bike with type "electric"
    And I go to end the ride page
    And I enter id of the bike
    And I enter id of the dock "26"
    When I click a end button
    Then I should see an ending ride error message

  Scenario: Rent a bike rejected by attempt to rent without return the previous one
      Given the following users exist
      | name | username | password | dateofbirth |    email      | creditcard |
      | Ramil| ramil    | bambum32 | 10.05.2020 | ramil@gmail.com| 1234324324322432|
      And I click on login button
      And I want to login to the account with username "ramil" and password "bambum32"
      And I write my credentials
      When I click a login submit button
      Given I rented the bike with type "classic"
      And I go to rent the bike page
      Then I should see a rejection message for return the previous one first