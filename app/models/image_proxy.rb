require 'open-uri'

module HazCommitz
  class ImageProxy
    def self.fetch(url)
      open(url).read
    end
  end
end
