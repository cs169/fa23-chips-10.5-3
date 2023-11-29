# frozen_string_literal: true

class Representative < ApplicationRecord
  has_many :news_items, dependent: :delete_all

  def self.civic_api_to_representative_params(rep_info)
    reps = []

    rep_info.officials.each_with_index do |official, index|
      ocdid_temp = ''
      title_temp = ''

      # Iterate through offices to find the office and division ID for the current official
      rep_info.offices.each do |office|
        if office.official_indices.include? index
          title_temp = office.name
          ocdid_temp = office.division_id
          break
        end
      end

      # Parse the address details
      address = official.address&.first # Assuming we take the first address
      street = address ? [address.line1, address.line2, address.line3].compact.join(' ') : ''
      city = address&.city
      state = address&.state
      zip = address&.zip

      # Create a new Representative record with the additional fields
      rep = Representative.create!({
        name: official.name,
        ocdid: ocdid_temp,
        title: title_temp,
        street: street,
        city: city,
        state: state,
        zip: zip,
        party: official.party,
        photo_url: official.photo_url
      })
      reps.push(rep)
    end

    reps
  end
end
