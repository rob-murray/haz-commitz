require "octokit"
require_relative 'base_controller'

module HazCommitz
    class ReposController < BaseController

        error Octokit::NotFound do
          halt 404, "Github Repository not found."
        end

        error Octokit::Unauthorized do
          halt 401, "Unauthorised to access Github Repository."
        end

        error Octokit::TooManyRequests do
            halt 503, "Github API rate limited exceeded. Try again soon."
        end

        get '/repos/?' do
            redirect to('/')
        end

        get '/repos/new' do
            erb :new
        end

        post '/repos/new' do
            repo_path = params['repo_path']

            if repo_path.nil? || repo_path.split('/').size != 2
                flash.next[:error] = "Invalid repository format"
                redirect to("/repos/new")
            else
                redirect to("/repos/#{repo_path}")
            end
        end

        get '/repos/:owner/:repo/?', :provides => ['html'] do |owner, repo|
            repo = fetch_and_rate_repo(owner, repo)

            erb :repo, :locals => { :repo => repo, :badge => badge(repo.rating) }
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
        
    end
end