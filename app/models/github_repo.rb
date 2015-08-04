# A repository model with the Github Api so it can fetch data
#
class GithubRepo < SimpleDelegator
  def initialize(repo, api_client)
    @api_client = api_client

    super post_initialize(repo, api_client)
  end

  private

  attr_reader :api_client

  def post_initialize(repo, api_client)
    repo.commits = latest_commits(repo.path)
    repo
  end

  def latest_commits(repo_path, branch = 'master')
    api_client.list_commits(repo_path, branch, max_commit_date).map do |api_response|
      Commit.build(
        api_response.sha,
        api_response.commit.author.name,
        api_response.commit.author.date,
        api_response.commit.message
      )
    end
  end

  def max_commit_date
    Time.zone.now - 6.months
  end
end
