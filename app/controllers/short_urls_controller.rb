class ShortUrlsController < ApplicationController

  # Since we're working on an API, we don't have authenticity tokens
  skip_before_action :verify_authenticity_token

  def index
  	@short_urls = ShortUrl.order('click_count DESC').limit(100)
    Rails.logger.info @short_urls.size
    render json: @short_urls
  end

  def create
    @url = ShortUrl.new(url_params)
    if @url.save
      render json: @url
    else
      render error: { error: 'Unable to create URL.' }, status: 400
    end
  end

  def show
      url_id = params[:short_code].to_i(16)
      @url = ShortUrl.find(url_id)
      @url.click_count += 1
      @url.save!
      if @url.save
        render json: @url
      end
  end

private

  def url_params
    params.require(:url).permit(:title, :full_url, :short_code)
  end

  def show_params
    params.require(:short_code)
  end

end
