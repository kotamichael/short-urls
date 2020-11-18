class ShortUrl < ApplicationRecord
  require 'public_suffix'
  require 'uri'

  CHARACTERS = [*'0'..'9', *'a'..'z', *'A'..'Z'].freeze

  validate :validate_full_url

  def short_code
  end

  def update_title!
  end

  private

  def validate_full_url
    Rails.logger.info "URL: #{self.full_url}"
    host = URI.parse(self.full_url).host
  	if PublicSuffix.valid?(host) != true
  		errors.add(:full_url, "is not a valid url")
  	end
  end

end
