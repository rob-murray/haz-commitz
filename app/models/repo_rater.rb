class RepoRater
  class << self
    def build(repo, rating_klasses = default)
      raters = Array(rating_klasses).map { |klass| klass.new(repo) }
      new(repo).rate_with(raters)
    end

    def default
      TimeBasedRepoRater
    end

    def rating_klass
      RepoRater::BaseRater
    end
  end

  MIN = 0
  MAX = 10

  def initialize(repo)
    @repo = repo
    @raters = []
  end

  def rate_with(rating_instances)
    @raters = Array(rating_instances)
    self
  end

  def rate
    total = raters_or_default.sum(&:rate)

    mean_avg(total)
  end

  private

  attr_reader :repo, :raters

  def raters_or_default
    @raters_or_default ||= raters.empty? ? Array(BaseRater.new(repo)) : raters
  end

  def mean_avg(total)
    total / raters_or_default.size
  end

  class BaseRater
    def initialize(repo)
      @repo = repo
    end

    def rate
      Rails.logger.warn 'This is the default method and should be implemented in subclass'

      min
    end

    protected

    attr_reader :repo

    def min
      MIN
    end

    def max
      MAX
    end
  end
end
