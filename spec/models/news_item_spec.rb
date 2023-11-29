# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NewsItem, type: :model do
  describe 'class methods' do
    describe 'find_for' do
      it 'returns nil if NewsItem is found for given representative_id' do
        nil_representative_id = 23

        found_news_item = described_class.find_for(nil_representative_id)

        expect(found_news_item).to be_nil
      end
    end
  end
end
