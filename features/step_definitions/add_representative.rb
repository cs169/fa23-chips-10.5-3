# frozen_string_literal: true

Given /^a representative named "(.*)" does not exist in the database$/ do |name|
  # destroy all instances of representative in database
  Representative.where(name: name).destroy_all
end

Given /^a representative named "(.*)" does exist in the database$/ do |name|
  Representative.find_or_create_by!(name: name)
end

When /^I add the representative "(.*)"$/ do |name|
  rep_name = OpenStruct.new(name: name)

  rep_info = OpenStruct.new(officials: [rep_name], offices: [])

  Representative.civic_api_to_representative_params(rep_info)
end

Then /^I should see the representative "(.*)" in the database$/ do |name|
  expect(Representative.find_by(name: name)).to be_present
end

Then /^I should see the representative "(.*)" (\d+) time(s)? in the database$/ do |name, count, _s|
  expect(Representative.where(name: name).count).to eq(count)
end
