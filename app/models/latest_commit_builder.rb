require_relative 'commit'

module HazCommitz
  class LatestCommitBuilder
    def initialize(github_api_client)
      @api_client = github_api_client
    end

    def latest_commit(repo_path, branch = 'master')
      commit_hash = @api_client.list_commits(repo_path, branch).first

      Commit.new(commit_hash.sha, commit_hash.commit.author.name, commit_hash.commit.author.date, commit_hash.commit.message)
    end
  end
end
