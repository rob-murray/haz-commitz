class RepositoryFetcher
  def initialize(github_api)
    @github_api = github_api
  end

  def repo(owner, repo)
    Repository.from_owner_and_name(owner, repo)
  end

  def rate_repo(repo)
    repo.add_commit(commit_builder.latest_commit(repo.path))
    repo.rate_with(repo_rater)

    repo
  end

  private

  def commit_builder
    LatestCommitBuilder.new(@github_api)
  end

  def repo_rater
    TimeBasedRepoRater.new
  end
end
