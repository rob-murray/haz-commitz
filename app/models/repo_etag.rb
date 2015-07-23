class RepoEtag
  class << self
    def etag(repository)
      new(repository).etag
    end
  end

  def initialize(repository)
    @repository = repository
  end

  def etag
    repository.latest_commit.sha
  end

  private

  attr_reader :repository
end
