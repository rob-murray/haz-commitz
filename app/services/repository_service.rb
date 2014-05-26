class RepositoryService
  def initialize(github_api)
    @github_api = github_api
  end

  def repo(owner, repo)
    Repository.new(owner, repo)
  end

  def repo_with_last_commit(owner, repo)
    repo = repo(owner, repo)
    repo.latest_commit = commit_builder.latest_commit(repo.path)

    repo
  end

  private

  def commit_builder
    LatestCommitBuilder.new(@github_api)
  end
end
