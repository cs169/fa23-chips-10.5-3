Feature: Add Representative to database
  As a developer
  So that I can see representatives in each county
  I want to be able to add representatives to the database

Scenario: Add a new representative
  Given a representative named "Gavin Newsom" does not exist in the database
  When I add the representative "Gavin Newsom"
  Then I should see the representative "Gavin Newsom" in the database

Scenario: Add a representative that already exists
  Given a representative named "Gavin Newsom" does exist in the database
  When I add the representative "Gavin Neswom"
  Then I should see the representative "Gavin Newsom" 1 time in the database