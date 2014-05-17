require 'octokit'
require_relative 'base_controller'

module HazCommitz
  class ReposController < BaseController
    ERROR_IMAGE = 'error_badge.svg'

    error do
      error_status(500, "An error occured: '#{request.env['sinatra.error']}'.")
    end

    error Octokit::NotFound do
      error_status(404, 'Github Repository not found.')
    end

    error Octokit::Unauthorized do
      error_status(401, 'Unauthorised to access Github Repository.')
    end

    error Octokit::TooManyRequests do
      error_status(503, 'Github API rate limited exceeded. Try again soon.')
    end

    get '/repos/?' do
      redirect to('/')
    end

    get '/repos/new' do
      erb :new
    end

    post '/repos/new' do
      repo = repo_from_path(params['repo_path'])

      if repo.nil?
        flash.next[:error] = 'Invalid repository format'
        redirect to('/repos/new')
      else
        redirect to("/repos/#{repo.path}")
      end
    end

    get '/repos/:owner/:repo/?', provides: ['html'] do |owner, repo|
      repo = fetch_and_rate_repo(owner, repo)

      erb :repo, locals: { repo: repo, badge: badge(repo.rating) }
    end

    get '/repos/:owner/:repo/badge.svg' do |owner, repo|
      repo = fetch_and_rate_repo(owner, repo)

      # set headers so GitHub's CDN correctly doesn't cache response
      content_type 'image/svg+xml'
      etag repo.latest_commit.sha
      cache_control 'no-cache, no-store, must-revalidate'

      ImageProxy.fetch(badge(repo.rating).display)
    end

    private

    def error_status(status, message = '')
      if request.path_info.include?('badge')
        file_path = File.join('app', 'public', ERROR_IMAGE)
        send_file(file_path, status: status, disposition: :inline, filename: ERROR_IMAGE)
      else
        halt status, message
      end
    end

    def fetch_and_rate_repo(owner, repo_name)
      repo = repo_service.repo_with_last_commit(owner, repo_name)
      repo.rate_with(repo_rater)

      repo
    end

    def github_client
      @client ||= GithubAdapter.new(github_api_token)
    end

    def repo_rater
      TimeBasedRepoRater.new
    end

    def repo_service
      @repo_service ||= RepositoryService.new(github_client)
    end

    def badge(repo_rating)
      BadgeUrlRatingPresenter.new(repo_rating)
    end

    def repo_from_path(repo_path)
      GithubRepository.new_from_path(repo_path)
    end
  end
end
