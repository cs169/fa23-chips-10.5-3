# frozen_string_literal: true

class MyNewsItemsController < SessionController
  before_action :set_representative
  before_action :set_representatives_list
  before_action :set_news_item, only: %i[edit update destroy]

  def new
    @news_item = NewsItem.new
  end

  def edit; end

  def search
    @issue = params[:issue]
    session[:issue] = @issue
    # Perform News API query and get top 5 articles
    @articles = fetch_top_articles_from_news_api
    # Render the search results view
    render 'search'
  end

  def save_news_item
    params[:issue] = session[:issue]
    @articles = fetch_top_articles_from_news_api
    selected_article_index = params[:selected_article].to_i
    selected_article = @articles[selected_article_index]

    # Now, you can save the selected article and its rating to the database
    @news_item = NewsItem.new(
      title:             selected_article[:title],
      link:              selected_article[:url],
      description:       selected_article[:description],
      representative_id: params[:representative_id],
      issue:             session[:issue]
    )
    if @news_item.save
      redirect_to representative_news_item_path(representative_id: params[:representative_id], id: @news_item.id),
                  notice: 'Article saved successfully!'
    else
      redirect_to representative_news_items_path(params[:representative_id]), alert: 'Failed to save the news item.'
    end
  end

  def create
    @news_item = NewsItem.new(news_item_params)
    if search_params_present?
      redirect_to search_my_news_items_path(search_params)
    elsif @news_item.save
      redirect_to representative_news_item_path(@representative, @news_item),
                  notice: 'News item was successfully created.'
    else
      render :new, error: 'An error occurred when creating the news item.'
    end
  end

  # if @news_item.save
  #   redirect_to representative_news_item_path(@representative, @news_item),
  #               notice: 'News item was successfully created.'
  # else
  #   render :new, error: 'An error occurred when creating the news item.'
  # end

  def update
    if @news_item.update(news_item_params)
      redirect_to representative_news_item_path(@representative, @news_item),
                  notice: 'News item was successfully updated.'
    else
      render :edit, error: 'An error occurred when updating the news item.'
    end
  end

  def destroy
    @news_item.destroy
    redirect_to representative_news_items_path(@representative),
                notice: 'News was successfully destroyed.'
  end

  private

  def search_params_present?
    params[:news_item] && params[:news_item][:representative_id] && params[:news_item][:issue]
  end

  def search_params
    params.require(:news_item).permit(:representative_id, :issue)
  end

  def set_representative
    @representative = Representative.find(
      params[:representative_id]
    )
  end

  def set_representatives_list
    @representatives_list = Representative.all.map { |r| [r.name, r.id] }
  end

  def set_news_item
    @news_item = NewsItem.find(params[:id])
  end

  # def set
  # end

  # Only allow a list of trusted parameters through.
  def news_item_params
    params.require(:news_item).permit(:news, :title, :description, :link, :representative_id, :issue)
  end

  def fetch_top_articles_from_news_api
    url = URI.parse('https://newsapi.org/v2/everything')
    url.query = URI.encode_www_form(
      apiKey: 'e289b48723ef4f7d9dd2da95e91e231c',
      q:      "#{@representative.name} #{params[:issue]}"
    )

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = (url.scheme == 'https')
    response = http.request(Net::HTTP::Get.new(url))

    if response.is_a?(Net::HTTPSuccess)
      JSON.parse(response.body)['articles'].first(5).map do |article|
        {
          title:       article['title'],
          url:         article['url'],
          description: article['description']
        }
      end

    else
      Rails.logger.error("Error fetching articles from News API: #{response.code} - #{response.body}")
    end
  end
end
