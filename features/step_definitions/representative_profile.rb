Given('I am on the county page') do
  visit '/search/Yamhill%20County'
end
When("I click on Jeff") do
  click_link('Jeff Merkley')
end
Given('Jeff exists in the database') do
  Representative.create!(
    name:   'Jeff Merkley',
    ocdid:  'ocdid109',
    title:  'U.S. Senator',
    street: '513 Hart Senate Office Building',
    city:   'Washington',
    state:  'DC',
    zip:    '20510',
    party:  'Democratic Party',
    photo_url:  'http://bioguide.congress.gov/bioguide/photo/M/M001176.jpg'

  )
end
When("I am on Jeffs profile") do
  rep = Representative.find_by(name: 'Jeff Merkley')
  visit representative_path(rep)
end
When("I search Oregon") do
  visit ('/search/Oregon')
end
Then('I see the name') do
  expect(page).to have_content('Jeff Merkley')
end
And('I see the party') do
  expect(page).to have_content('Democratic Party')
end
And('I see the city') do
  expect(page).to have_content('Washington')
end
And('I see the zip') do
  expect(page).to have_content('20510')
end
And('I see the title') do
  expect(page).to have_content('U.S. Senator')
end
And('I see the street') do
  expect(page).to have_content('513 Hart Senate Office Building')
end
And('I see their picture') do
  expect('http://bioguide.congress.gov/bioguide/photo/M/M001176.jpg').to be_present
end
