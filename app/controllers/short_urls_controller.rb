class ShortUrlsController < ApplicationController

  # Since we're working on an API, we don't have authenticity tokens
  skip_before_action :verify_authenticity_token

  def index
  	@short_urls = ShortUrl.all
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
      url = ShortUrl.find(url_params[:full_url])
  end

private

  def url_params
    params.require(:url).permit(:title, :full_url)
  end

end
