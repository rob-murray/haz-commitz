class RepositoryController < ApplicationController
  unless Rails.env.development?
    rescue_from Exception, with: :something_went_wrong
    rescue_from BadgeRequestError, with: :something_went_wrong
    rescue_from Octokit::NotFound, with: :repository_not_found
    rescue_from Octokit::Unauthorized, with: :repository_not_authorised
    rescue_from Octokit::TooManyRequests, with: :over_api_limit
  end

  def show
    @repo = rated_repo

    respond_to do |format|
      format.html do
        @letter_rating = letter_for_rating(@repo.rating)
      end
      format.svg do
        badge = badge_for_rating(@repo.rating)

        expires_now
        if stale?(etag: [RepoEtag.etag(@repo), AppConfig.badge_version])
          render inline: ImageProxy.fetch(badge.display)
        end
      end
    end
  end

  def new
    @repo = NewRepositoryForm.new
  end

  def create
    repo = NewRepositoryForm.new(new_repo_params)

    if repo.valid?
      redirect_to repository_path user_id: repo.owner, id: repo.name
    else
      flash[:error] = repo.errors.full_messages.to_sentence
      redirect_to new_repository_path
    end
  end

  private

  def new_repo_params
    params.require(:new_repository_form).permit(:path)
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
    render_error :internal_server_error, 'Ooops. An error occured, sorry about that.'
  end

  def render_error(status, message = '')
    respond_to do |f|
      f.html { render plain: message, status: status }
      f.svg do
        error_badge = File.join(Rails.public_path, 'error_badge.svg')
        render file: error_badge, status: status
      end
    end
  end

  def rated_repo
    GithubRepo.new(repo_from_params, github_client)
  end

  def repo_from_params
    Repository.from_owner_and_name(params[:user_id], params[:id])
  end

  def github_client
    @github_client ||= GithubAdapter.new(Rails.application.secrets.github_api_key)
  end

  def badge_for_rating(repo_rating)
    BadgeUrlRatingPresenter.new(repo_rating)
  end

  def letter_for_rating(rating)
    LetterRatingPresenter.new(rating).letter
  end

  def rating_klasses
    [TimeBasedRepoRater, CommitCountRater]
  end
end
