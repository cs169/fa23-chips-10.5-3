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
    representative = Representative.find_by(name: official.name)
    if representative
      Representative.assign(representative, official, title_temp, ocdid_temp)
      if representative.ocdid == ocdid_temp
      # Update all attributes except ocdid if ocdid matches ocdid_temp
      else
        # Update all attributes, including ocdid if it does not match ocdid_temp
        representative.assign_attributes({ ocdid: ocdid_temp })
      end
    else
      # If no representative is found, create a new one
      representative = Representative.find_or_initialize_by(name: official.name, ocdid: ocdid_temp)
      Representative.assign(representative, official, title_temp, ocdid_temp)
    end

    representative.save if representative.changed?
    representative
  end

  def self.assign(representative, official, title_temp, _ocdid_temp)
    address = official.address&.first
    street = address ? [address.line1, address.line2, address.line3].compact.join(' ') : ''
    city = address&.city
    state = address&.state
    zip = address&.zip
    representative.assign_attributes({
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
