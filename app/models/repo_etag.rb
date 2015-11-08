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
    latest_commit_sha
  end

  private

  attr_reader :repository

  def latest_commit_sha
    repository.latest_commit.present? ? repository.latest_commit.sha : SecureRandom.hex
  end
end
