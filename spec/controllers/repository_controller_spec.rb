require 'rails_helper'

RSpec.describe RepositoryController, type: :controller do
  context 'given a request with repos path' do
    before { get :index }

    it 'responds with redirect' do
      expect(response).to be_redirect
    end

    it 'redirects to root view' do
      expect(response).to redirect_to(root_url)
    end
  end

  context 'given a request with repo owner and name' do
    let(:repo) do
      repo = Repository.new('owner_name', 'repo_name')
      repo.add_commit(commit)
      repo
    end

    let(:commit) do
      Commit.new('sha-12345', 'joe bloggs', time_days_ago(7), 'i fixed stuff')
    end

    before do
      allow_any_instance_of(RepositoryFetcher).to receive(:rate_repo).and_return(repo)
    end

    context 'with valid repo' do
      context 'html request' do
        before { get :show, user_id: 'owner_name', id: 'repo_name' }

        it 'requests repository data' do
          expect_any_instance_of(RepositoryFetcher).to receive(:rate_repo).and_return(repo)

          get :show, user_id: 'owner_name', id: 'repo_name'
        end

        it 'returns ok response' do
          expect(response).to be_ok
        end

        it 'renders repository view' do
          expect(response).to render_template(:show)
        end

        it 'passes repository to view' do
          expect(assigns(:repo).path).to eq(repo.path)
        end
      end

      context 'badge request' do
        before { get :show, user_id: 'owner_name', id: 'repo_name', format: :svg }

        it 'requests repository data' do
          expect_any_instance_of(RepositoryFetcher).to receive(:rate_repo).and_return(repo)

          get :show, user_id: 'owner_name', id: 'repo_name', format: :svg
        end

        it 'returns ok response' do
          expect(response).to be_ok
        end

        it 'responds with svg content type' do
          expect(response.content_type).to include('image/svg+xml')
        end

        it 'should return an image'

        it 'should set etag in response headers' do
          expect(response.etag).to be_present
        end

        it 'does not set caching directive' do
          expect(response['Cache-Control']).to eq('no-cache')
        end
      end
    end

    context 'with a repo that does not exist' do
      before do
        allow_any_instance_of(RepositoryFetcher).to receive(:rate_repo).and_raise(Octokit::NotFound)
      end

      context 'html request' do
        before { get :show, user_id: 'owner_name', id: 'repo_name' }

        it 'returns not found status' do
          expect(response.status).to eq(404)
        end
      end

      context 'badge request' do
        before { get :show, user_id: 'owner_name', id: 'repo_name', format: :svg }

        it 'returns not found status' do
          expect(response.status).to eq(404)
        end

        it 'returns an error image' do
          # will treat this as an image test until that is actually fixed
          expect(response.content_type).to include('image/svg+xml')
        end
      end
    end

    context 'with a repo that is unauthorised' do
      before do
        allow_any_instance_of(RepositoryFetcher).to receive(:rate_repo).and_raise(Octokit::Unauthorized)
      end

      context 'html request' do
        before { get :show, user_id: 'owner_name', id: 'repo_name' }

        it 'returns unauthorised status' do
          expect(response.status).to eq(401)
        end
      end

      context 'badge request' do
        before { get :show, user_id: 'owner_name', id: 'repo_name', format: :svg }

        it 'returns unauthorised status' do
          expect(response.status).to eq(401)
        end

        it 'returns an error image' do
          # will treat this as an image test until that is actually fixed
          expect(response.content_type).to include('image/svg+xml')
        end
      end
    end

    context 'when the GitHub API rate limit is exceeded' do
      before do
        allow_any_instance_of(RepositoryFetcher).to receive(:rate_repo).and_raise(Octokit::TooManyRequests)
      end

      context 'html request' do
        before { get :show, user_id: 'owner_name', id: 'repo_name' }

        it 'returns service unavailble status' do
          expect(response.status).to eq(503)
        end
      end

      context 'badge request' do
        before { get :show, user_id: 'owner_name', id: 'repo_name', format: :svg }

        it 'returns service unavailble status' do
          expect(response.status).to eq(503)
        end

        it 'returns an error image' do
          # will treat this as an image test until that is actually fixed
          expect(response.content_type).to include('image/svg+xml')
        end
      end
    end

    context 'when badge service is down' do
      before do
        allow(ImageProxy).to receive(:fetch).and_raise(BadgeRequestError)
      end

      context 'html request' do
        before { get :show, user_id: 'owner_name', id: 'repo_name' }

        it 'returns valid response' do
          expect(response.status).to eq(200)
        end
      end

      context 'badge request' do
        before { get :show, user_id: 'owner_name', id: 'repo_name', format: :svg }

        it 'returns service unavailble status' do
          expect(response.status).to eq(500)
        end

        it 'returns an error image' do
          # will treat this as an image test until that is actually fixed
          expect(response.content_type).to include('image/svg+xml')
        end
      end
    end

    context 'when an exception is thrown' do
      before do
        allow_any_instance_of(RepositoryFetcher).to receive(:rate_repo).and_raise(Exception)
      end

      context 'html request' do
        before { get :show, user_id: 'owner_name', id: 'repo_name' }

        it 'returns service unavailble status' do
          expect(response.status).to eq(500)
        end
      end

      context 'badge request' do
        before { get :show, user_id: 'owner_name', id: 'repo_name', format: :svg }

        it 'returns service unavailble status' do
          expect(response.status).to eq(500)
        end

        it 'returns an error image' do
          # will treat this as an image test until that is actually fixed
          expect(response.content_type).to include('image/svg+xml')
        end
      end
    end
  end

  context 'given a get request to add a repository' do
    before { get :new }

    it 'returns valid response' do
      expect(response).to be_success
    end

    it 'renders new view' do
      expect(response).to render_template('repository/new')
    end

  end

  context 'given a post request for new repository' do
    context 'given a request in valid format' do
      before do
        allow_any_instance_of(RepositoryFetcher).to receive(:rate_repo).and_return(repo)

        post :create, repository: { path: 'owner_name/repo_name' }
      end

      let(:repo) do
        Repository.new('owner_name', 'repo_name')
      end

      let(:commit) do
        Commit.new('sha-12345', 'joe bloggs', time_days_ago(7), 'i fixed stuff')
      end

      it 'returns redirect' do
        expect(response).to be_redirect
      end

      it 'redirects to repo view' do
        expect(response).to redirect_to action: :show, user_id: repo.owner, id: repo.name

        # not interested if the response is valid, but need to stub repo service to avoid hitting api
        expect(response).to redirect_to("/repos/#{repo.path}")
      end
    end

    context 'with invalid data from form' do

      before { post :create, repository: { path: 'blah' } }

      it 'returns redirect' do
        expect(response).to be_redirect
      end

      it 'redirects to new view' do
        expect(response).to redirect_to action: :new
      end

      it 'displays flash message' do
        expect(flash[:error]).to match(/Invalid repository format/)
      end
    end
  end
end
