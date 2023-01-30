Feature: Invoice
  As a user I want to see my invoice for the bike ridden
  so I pay the bills

Scenario: see an invoice
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
    Given I rented the bike with type "electric"
    And I go to end the ride page
    And I enter id of the bike
    And I enter id of the dock
    When I click a end button
    Then I should see my invoice page
