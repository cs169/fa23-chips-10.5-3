Feature: County Interaction
  As a user
  I want to interact with the counties list on the state page
  So that I can view representatives about different counties
  
  Scenario Outline: Viewing representatives of a county
   Given I am on the homepage 
   When I choose a state "CA"
   When I expand the county details section
   When I click the view button of a county "Orange"
   Then I should see the representatives of the county "Orange"