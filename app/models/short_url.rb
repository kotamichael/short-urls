class ShortUrl < ApplicationRecord
  require 'public_suffix'
  require 'uri'

  CHARACTERS = [*'0'..'9', *'a'..'z', *'A'..'Z'].freeze

  validates :full_url, presence: true, uniqueness: true
  validate :validate_full_url
  before_save :add_short_code

  def update_title!
  end

  private

  def add_short_code
    decimal_id = ShortUrl.all.size + 1
    self.short_code = decimal_id.to_s(16)
  end

  def validate_full_url
    host = URI.parse(self.full_url).host
  	if PublicSuffix.valid?(host) != true
  		errors.add(:full_url, "is not a valid url")
  	end
  end

end
