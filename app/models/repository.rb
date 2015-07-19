class Repository
  include Virtus.model

  attribute :commits, Array, default: [], writer: :private
  attribute :rating, Integer, default: 0, writer: :private
  attribute :owner, String
  attribute :name, String

  class << self
    def from_owner_and_name(owner, name)
      new(owner: owner, name: name)
    end
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
