# frozen_string_literal: true

class NewsItemsController < ApplicationController
  before_action :set_representative
  before_action :set_news_item, only: %i[show]

  def index
    @representative = Representative.find(params[:representative_id])
    @news_items = @representative.news_items
    Rails.logger.debug { "News Items: #{@news_items}" }
    @news_items.each do |ni|
      Rails.logger.debug ni.inspect
    end
  end

  def show; end

  private

  def set_representative
    @representative = Representative.find(
      params[:representative_id]
    )
  end

  def set_news_item
    @news_item = NewsItem.find(params[:id])
  end
end
