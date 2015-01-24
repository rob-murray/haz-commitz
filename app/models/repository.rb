class Repository < Struct.new(:owner, :name)
  INTITAL_RATING = 0

  attr_reader :commits, :rating

  def initialize(*args)
    super(*args)

    @rating = INTITAL_RATING
    @commits = []
  end

  def persisted?
    false
  end

  def path
    "#{owner}/#{name}"
  end

  def add_commit(commit)
    commits << commit unless commit.nil?
  end

  def latest_commit
    commits.last
  end

  def latest_commit_date
    latest_commit.date
  end

  def rate_with(rating_strategy)
    @rating = rating_strategy.rate(self)
  end
end
