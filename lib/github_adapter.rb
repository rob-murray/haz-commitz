require 'octokit'
require 'faraday/http_cache'

class GithubAdapter
  def initialize(token)
    stack = Faraday::RackBuilder.new do |builder|
      builder.use Faraday::HttpCache
      builder.use Octokit::Response::RaiseError
      builder.adapter Faraday.default_adapter
    end
    Octokit.middleware = stack

    @client = Octokit::Client.new(access_token: token)
  end

  def list_commits(repo_path, branch)
    # https://developer.github.com/v3/repos/commits/#list-commits-on-a-repository
    @client.list_commits(repo_path, sha: branch)
  end
end
