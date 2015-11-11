module AppConfig
  class << self
    attr_accessor :configuration

    delegate :badge_version, to: :configuration

    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end

    def reset
      @configuration = Configuration.new
    end
  end

  class Configuration
    attr_accessor :badge_version

    def initialize
      @badge_version = "VERSION_003"
    end
  end
end
