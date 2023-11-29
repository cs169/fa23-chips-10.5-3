# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Event, type: :model do
  describe '#county_names_by_id' do
    it 'returns an empty hash when county, state, or counties are nil' do
      event = described_class.create(county: nil)

      expect(event.county_names_by_id).to eq({})
    end
  end
end
