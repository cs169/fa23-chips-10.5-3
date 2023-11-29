
Feature: Representative View
  Scenario: Click on a rep's profile
    Given I am on the county page
    When I click on Jeff
    Then I see the name
  Scenario: Viewing a rep's profile
    Given Jeff exists in the database
    When I am on Jeffs profile
    Then I see the name
    And I see the party
    And I see the city
    And I see their picture
    And I see the zip
    And I see the title
    And I see the street
  Scenario: Going to a rep's profile via search of Oregon
    Given Jeff exists in the database
    When I search Oregon
    When I click on Jeff
    Then I see the name
    And I see the party
    And I see their picture
    And I see the city
    And I see the zip
    And I see the title
    And I see the street