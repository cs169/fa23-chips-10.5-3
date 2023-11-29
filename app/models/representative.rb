# frozen_string_literal: true

class Representative < ApplicationRecord
  has_many :news_items, dependent: :delete_all

  def self.civic_api_to_representative_params(rep_info)
    reps = []

    rep_info.officials.each_with_index do |official, index|
      ocdid_temp = ''
      title_temp = ''

      rep_info.offices.each do |office|
        next unless office.official_indices.include? index

        title_temp = office.name
        ocdid_temp = office.division_id
        break
      end

      rep = Representative.create_helper(official, title_temp, ocdid_temp)

      reps.push(rep)
    end

    reps
  end

  def self.create_helper(official, title_temp, ocdid_temp)
    address = official.address&.first # Assuming we take the first address
    street = address ? [address.line1, address.line2, address.line3].compact.join(' ') : ''
    city = address&.city
    state = address&.state
    zip = address&.zip

    Representative.create!({
                             name:      official.name,
                             ocdid:     ocdid_temp,
                             title:     title_temp,
                             street:    street,
                             city:      city,
                             state:     state,
                             zip:       zip,
                             party:     official.party,
                             photo_url: official.photo_url
                           })
  end
end
