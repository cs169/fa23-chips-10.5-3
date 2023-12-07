# frozen_string_literal: true

# features/step_definitions/my_news_items_steps.rb

Given(/^I am on the search articles page$/) do
  visit search_my_news_items_path(:representative_id, :issue)
end

When(/^I click on the first article$/) do
  # TODO
end

When(/^I enter '(.+)' as a rating$/) do |rating|
  # TODO
end

When(/^I click the save button$/) do
  # TODO
end

Then(/^the article should be in the database$/) do
  # Assuming you are using ActiveRecord
end
