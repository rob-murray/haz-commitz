class RepositoryController < ApplicationController
  rescue_from Exception, with: :something_went_wrong
  rescue_from Octokit::NotFound, with: :repository_not_found
  rescue_from Octokit::Unauthorized, with: :repository_not_authorised
  rescue_from Octokit::TooManyRequests, with: :over_api_limit

  def index
    redirect_to root_url
  end

  def show
    @repo = fetch_and_rate_repo(params[:user_id], params[:id])

    respond_to do |format|
      format.html
      format.svg do
        badge = badge(@repo.rating)
        expires_now
        fresh_when(@repo.latest_commit.sha)
        render text: ImageProxy.fetch(badge.display)
      end
    end
  end

  def new
    @repo = Repository.new
  end

  def create
    repo = Repository.new_from_path(new_repo_params[:path])

    if repo.nil?
      flash[:error] = 'Invalid repository format'
      redirect_to new_repository_path
    else
      redirect_to repository_path user_id: repo.owner, id: repo.name
    end
  end

  private

  def new_repo_params
    params.require(:repository).permit(:path)
  end

  def repository_not_found
    render_error :not_found, 'Github Repository not found.'
  end

  def repository_not_authorised
    render_error :unauthorized, 'Unauthorised to access Github Repository.'
  end

  def over_api_limit
    render_error :service_unavailable, 'Github API rate limited exceeded. Try again soon.'
  end

  def something_went_wrong
    render_error :internal_server_error, 'Ooops'
  end

  def render_error(status, message = '')
    respond_to do |f|
      f.html { render plain: message, status: status }
      f.svg do
        error_badge = File.join(Rails.public_path, 'error_badge.svg')
        render text: File.read(error_badge), status: status
      end
    end
  end

  # TODO: move these...

  def fetch_and_rate_repo(owner, repo_name)
    repo = repo_service.repo_with_last_commit(owner, repo_name)
    repo.rate_with(repo_rater)

    repo
  end

  def github_client
    @client ||= GithubAdapter.new(Rails.application.secrets.github_api_key)
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
