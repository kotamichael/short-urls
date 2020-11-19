class ShortUrlsController < ApplicationController
  # Since we're working on an API, we don't have authenticity tokens
  skip_before_action :verify_authenticity_token

  def index
  	@top_hundred_full_urls = ShortUrl.order('click_count DESC').limit(100)
    render json: {
      urls: @top_hundred_full_urls
    }
  end

  def create
    is_duplicate_url = ShortUrl.where(full_url: url_params).present?

    if !is_duplicate_url
      @url = ShortUrl.new(full_url: url_params)
    else
      render json: { error: 'Must be a unique URL.' }, status: 400
      return
    end

    if @url.save
      render json: @url
    else
      render json: { error: 'Unable to create URL. Maybe an invalid format.' }, status: 400
    end
  end

  def show
      url_id = params[:short_code].to_i(16)
      @url = ShortUrl.find(url_id)
      @url.click_count += 1
      @url.save!
      if @url.save
        render json: @url.full_url
      end
  end

private

  def url_params
    params.require(:full_url)
  end

  def show_params
    params.require(:short_code)
  end

end
