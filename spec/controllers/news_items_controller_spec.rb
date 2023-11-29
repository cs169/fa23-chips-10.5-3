# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NewsItemsController, type: :controller do
  let(:representative) { Representative.create(name: 'Example Representative') }
  let(:news_item) { NewsItem.create(title: 'Title', link: 'http://example.com', representative: representative) }

  describe 'GET #index' do
    it 'renders the index template' do
      get :index, params: { representative_id: representative.id }
      expect(response).to render_template(:index)
    end

    it 'assigns news items for the representative to @news_items' do
      get :index, params: { representative_id: representative.id }
      expect(assigns(:news_items)).to eq([news_item])
    end
  end

  describe 'GET #show' do
    it 'renders the show template' do
      get :show, params: { representative_id: representative.id, id: news_item.id }
      expect(response).to render_template(:show)
    end

    it 'assigns the requested news item to @news_item' do
      get :show, params: { representative_id: representative.id, id: news_item.id }
      expect(assigns(:news_item)).to eq(news_item)
    end
  end

  private

  def news_item_params
    {
      news:              'Example News',
      title:             'Example Title',
      description:       'Example Description',
      link:              'http://example.com',
      representative_id: representative.id
    }
  end
end
