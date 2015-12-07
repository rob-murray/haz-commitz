class Repository
  include FiveStar.rateable
  include Virtus.model

  rate_with LastCommitDateRater, CommitCountRater, StarCountRater

  attribute :commits, Array[Commit], default: []
  attribute :owner, String
  attribute :name, String
  attribute :stars, Integer, default: 0

  class << self
    def from_owner_and_name(owner, name)
      new(owner: owner, name: name)
    end
  end

  def persisted?
    false
  end

  def rating
    super.round
  end

  def path
    "#{owner}/#{name}"
  end

  def add_commit(commit)
    commits << commit unless commit.nil?
  end

  def latest_commit
    commits.first
  end

  def latest_commit_date
    latest_commit.date if commits.any?
  end
end
