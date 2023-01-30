Feature: Booking
    As a user, I want to book a bike before the real-time I actually use it, 
    so I can make sure there is a bike available when I am going to use it.

  Scenario: Book a bike with a confirmation
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

  Scenario: Book a bike with non-existent id rejection
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
    And I go to book the bike page
    And I enter id of the bike
    When I click a book button
    Then I should see a booking rejection message