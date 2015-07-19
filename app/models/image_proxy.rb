require 'open-uri'

class ImageProxy
  def self.fetch(url)
    new(url).fetch
  end

  def initialize(url)
    @url = url
  end

  def fetch
    open(url, read_timeout: 10).read
  rescue => e
    Rails.logger.error e
    raise BadgeRequestError
  end

  private

  attr_reader :url
end
