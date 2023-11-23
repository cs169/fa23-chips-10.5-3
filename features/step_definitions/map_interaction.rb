# frozen_string_literal: true

Given('I am on the homepage') do
  visit root_path
end

When('I choose a state {string}') do |state|
  # Navigate to the state page.
  # The state_map_path should be replaced with the actual path or URL helper for the state page in your application.
  visit state_map_path(state_symbol: state)
end

When('I expand the county details section') do
  # Find and click the button to expand the county details
  find('#actionmap-counties-details-header button.collapsed', wait: 10).click
end

When('I click the view button of a county {string}') do |county_name|
  within('#actionmap-state-counties-details') do
    click_link('View', href: /#{county_name}/)
  end
end

Then('I should see the representatives of the county {string}') do |county_name|
  # Check if the page has content related to the representatives of the specified county.
  # This might involve checking for specific elements, text, or titles on the page.
  expect(page).to have_content(county_name)
  expect(page).to have_content('Shari L. Freidenrich')
  expect(page).to have_content('Todd Spitzer')
end
