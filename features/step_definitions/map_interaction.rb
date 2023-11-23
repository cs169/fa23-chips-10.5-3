Given('I am on the homepage') do
  visit root_path
end

When('I select the state {string}') do |state_symbol|
  visit state_map_path(state_symbol: state_symbol)
end

When('I click on the county link {string}') do |county|
  within('#actionmap-state-counties-details') do
    click_link county
  end
end


Then('I should see details for county {string}') do |county_name|
  expect(page).to have_content(county_name)
  # Additional checks for county details can be added here
end