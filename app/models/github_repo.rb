# A repository model with the Github Api so it can fetch data
#
class GithubRepo < DelegateClass(Repository)
  def initialize(repo, api_client)
    @api_client = api_client

    super post_initialize(repo, api_client)
  end

  private

  attr_reader :api_client

  def post_initialize(repo, api_client)
    repo.tap do |r|
      r.commits = latest_commits(r.path)
      r.stars = stars_count(r.path)
    end
  end

  def latest_commits(repo_path, branch = 'master')
    api_client.list_commits(repo_path, branch, oldest_commit_date).map do |api_response|
      Commit.build(
        api_response.sha,
        api_response.commit.author.name,
        api_response.commit.author.date,
        api_response.commit.message
      )
    end
  end

  def stars_count(repo_path)
    api_client.stars_count(repo_path)
  end

  def oldest_commit_date
    Time.zone.now - 6.months
  end
end
