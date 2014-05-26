require 'open-uri'

class ImageProxy
  def self.fetch(url)
    open(url).read
  end
end
