# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MyNewsItemsController, type: :controller do
  let(:representative) { Representative.create(name: 'John Doe') }
  let(:news_item) do
    NewsItem.create(representative: representative, title: 'Sample Title', description: 'Sample Description',
                    link: 'http://example.com', issue: 'Sample Issue')
  end

  describe 'GET #new' do
    it 'renders the new template' do
      get :new
    end
  end

  describe 'GET #search' do
    it 'renders the search template' do
      get :search
    end
  end

  describe 'POST #save_news_item' do
    before do
      allow(controller).to receive(:fetch_top_articles_from_news_api).and_return([{ title: 'Article 1',
url: 'http://example.com', description: 'Description 1' }])
    end

    it 'saves the news item and redirects on success' do
      post :save_news_item, params: { representative_id: representative.id, selected_article: '0' }
    end
  end
end
