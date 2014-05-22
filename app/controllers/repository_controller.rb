class RepositoryController < ApplicationController
  def index
    redirect_to root_url
  end

  def show

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
      redirect_to "/repos/#{repo.path}"
    end
  end

  private

  def new_repo_params
    params.require(:repository).permit(:path)
  end
end
