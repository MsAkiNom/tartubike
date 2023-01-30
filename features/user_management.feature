Feature: User management
  As a user
  Such that I want use Tartu bike sharing services 
  I want to create account, edits profile and view my ride statistics

  Scenario: Create new account 
    Given I click on register button
    And I set a username "jtm" with password "qwerty@123"
    And I add my name "Worraanong Chanchaijak", email "c.worraanong@gmail.com", birthday "27/09/1993" 
    And I have a credit card with number "5555555555554444" 
    And I fill required information
    And I add credit card information
    When I click a submit button
    Then I should view confirmation message for register successfully

  Scenario: Create new account without payment method 
    Given I click on register button
    And I set a username "jtm" with password "qwerty@123"
    And I add my name "Worraanong Chanchaijak", email "c.worraanong@gmail.com", birthday "27/09/1993" 
    And I fill required information
    When I click a submit button
    Then I should see no payment method detail error

  Scenario: Logging in with confirmation
    Given the following users exist
      | name | username | password | dateofbirth |    email      | creditcard |
      | Ramil| ramil    | bambum32 | 10.05.2020 | ramil@gmail.com| 1234324324322432|
      | Bumif| baerm    | bsdfbum32 | 13.05.2020 | rmil@gmail.com| 3423423423422432|
    And I click on login button
    And I want to login to the account with username "ramil" and password "bambum32"
    And I write my credentials
    When I click a login submit button
    Then I should see a confirmation of authenthication
