Feature: Save News Item and Search

  Scenario: Save a news item
    Given I am on the search articles page
    When I click on the first article
    When I enter '5 stars' as a rating
    When I click the save button
    Then the article should be in the database