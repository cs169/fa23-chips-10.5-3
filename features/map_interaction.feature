Feature: County Interaction
  As a user
  I want to interact with the counties list on the state page
  So that I can view details about different counties

  Scenario Outline: Viewing details of a county from the list
    Given I am on the homepage
    When I select the state "<state>"
    And I click on the link for county "<county>"
    Then I should see details for county "<county>"

  Examples:
    | state | county      |
    | TX    | Travis      |
    | CA    | Los Angeles |
    | NY    | Albany      |