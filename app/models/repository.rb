class Repository
  include ActiveModel::Model
  INTITAL_RATING = 0

  attr_reader :owner, :name, :commits
  attr_accessor :rating

  validates :owner, presence: true
  validates :name, presence: true

  def initialize(owner = nil, repo_name = nil)
    @owner = owner
    @name = repo_name

    @rating = INTITAL_RATING
    @commits = []
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

  def self.new_from_path(repo_path)
    unless repo_path.nil? || repo_path.split('/').size != 2
      Repository.new(*repo_path.split('/'))
    end
  end
end
