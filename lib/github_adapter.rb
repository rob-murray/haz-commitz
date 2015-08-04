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

  def list_commits(repo_path, branch, since)
    # https://github.com/octokit/octokit.rb/blob/07036916bfb42e98a0627616aeabc68582296737/lib/octokit/client/commits.rb#L48
    @client.commits_since(repo_path, since, sha: branch)
  end
end
