require 'open-uri'

class ImageProxy
  def self.fetch(url)
      open(url).read
    rescue => e
      Rails.logger.warn e
      raise BadgeRequestError
  end
end
