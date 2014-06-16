require 'open-uri'

class ImageProxy
  def self.fetch(url)
    begin
      open(url).read
    rescue => e
      Rails.error e
      raise BadgeRequestError
    end
  end
end
