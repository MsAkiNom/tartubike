Feature: Bike-sharing system
  As a user, I want to report technical problems that I face
    so that I can use the bikes and the application itself without any issues.
  Scenario: Reporting the issue
    Given the following users exist
    | name | username | password | dateofbirth |    email      | creditcard |
    | Ramil| ramil    | bambum32 | 10.05.2020 | ramil@gmail.com| 1234324324322432|
    | Bumif| baerm    | bsdfbum32 | 13.05.2020 | rmil@gmail.com| 3423423423422432|
    And I click on login button
    And I want to login to the account with username "ramil" and password "bambum32"
    And I write my credentials
    When I click a login submit button
    Then I should see a confirmation of authenthication
    When I click on report issue button
    And I set a bikeid to "5" with the title "failed to unlock a bike"
    And I add my issue "I am having an issue in unlocking the bike that i recently rented" 
    And I fill the necessary information
    When I click on a save button
    Then I should see a successfully created report message along with the preview of the submitted report form

Scenario: Reporting the issue for fail
    Given the following users exist
    | name | username | password | dateofbirth |    email      | creditcard |
    | Ramil| ramil    | bambum32 | 10.05.2020 | ramil@gmail.com| 1234324324322432|
    | Bumif| baerm    | bsdfbum32 | 13.05.2020 | rmil@gmail.com| 3423423423422432|
    And I click on login button
    And I want to login to the account with username "ramil" and password "bambum32"
    And I write my credentials
    When I click a login submit button
    Then I should see a confirmation of authenthication
    When I click on report issue button
    And I set a bikeid to "5"
    And I add my issue "I am having an issue in unlocking the bike that i recently rented" 
    When I click on a save button
    Then I should get a failure message
