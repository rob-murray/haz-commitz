
class Repository
  include ActiveModel::Model

  attr_reader :owner, :name
  attr_accessor :latest_commit, :rating

  validates :owner, presence: true
  validates :name, presence: true

  def initialize(owner = nil, repo_name = nil)
    @owner = owner
    @name = repo_name

    @rating = 0
  end

  def path
    "#{owner}/#{name}"
  end

  def rate_with(rating_strategy)
    @rating = rating_strategy.rate(self)
  end

  def self.new_from_path(repo_path)
    if repo_path.nil? || repo_path.split('/').size != 2
      nil
    else
      Repository.new(*repo_path.split('/'))
    end
  end
end
