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
    @representative_name = @representative.name
    @issue = params[:issue]
    # Perform News API query and get top 5 articles
    @articles = fetch_top_articles_from_news_api

    # Render the search results view
    render 'search'
  end

  def select_article
    selected_index = params[:selected_article].to_i

    # Use the selected_index to retrieve the corresponding article from @articles
    @selected_article = @articles[selected_index]

    # Add your logic to handle the selected article, e.g., save it to the database

    # Redirect or render a new view as needed
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
    # Set your News API key
    api_key = 'e289b48723ef4f7d9dd2da95e91e231c'
  
    # Combine representative name and issue as keywords
    keywords = "#{@representative.name} #{params[:issue]}"
  
    # Build the URL with the q (query) parameter
    url = URI.parse("https://newsapi.org/v2/everything")
    url.query = URI.encode_www_form(
      apiKey: api_key,
      q: keywords       # Add the q parameter with representative name and issue
    )
  
    # Make a request to the News API
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = (url.scheme == 'https')
  
    request = Net::HTTP::Get.new(url)
    response = http.request(request)
  
    # Check if the request was successful
    if response.is_a?(Net::HTTPSuccess)
      # Parse the JSON response and extract relevant information
      articles = JSON.parse(response.body)['articles'].first(5).map do |article|
        {
          title: article['title'],
          url: article['url'],
          description: article['description']
        }
      end
  
      return articles
    else
      # Handle the error
      Rails.logger.error("Error fetching articles from News API: #{response.code} - #{response.body}")
      return [] # Return an empty array in case of an error
    end
  end
  
  
end
