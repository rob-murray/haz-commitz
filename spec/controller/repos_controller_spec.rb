require 'spec_helper'

describe HazCommitz::ReposController do
    include Webrat::Matchers

    context "given a request with repos path" do

        before { get("/repos") }

        it "should return redirect" do
            expect(last_response).to be_redirect
        end

        it "should redirect to root view" do
            follow_redirect!

            expect(last_response).to be_ok
            expect(last_request.url).to match('/')
        end

    end

    context "given a request with repo owner and name" do

        before do
            HazCommitz::RepositoryService.any_instance.stubs(:repo_with_last_commit).returns(repo)
            repo.stubs(:latest_commit).returns(commit)
        end

        let(:repo) do
            HazCommitz::GithubRepository.new('owner_name', 'repo_name')
        end

        let(:commit) do
            HazCommitz::Commit.new("sha-12345", "joe bloggs", time_days_ago(7), "i fixed stuff")
        end

        context "with valid repo" do

            context "to html url" do

                before { get("/repos/owner_name/repo_name") }

                it "should request repo info" do
                    HazCommitz::RepositoryService.any_instance.expects(:repo_with_last_commit).with('owner_name', 'repo_name').returns(repo)
                    get("/repos/owner_name/repo_name")
                end

                it "should return valid response" do
                    expect(last_response).to be_ok
                end

                it "should render repo view" do
                    expect(last_response.body).to have_selector("div#repo")
                end

                it "should display repo owner and name" do
                    expect(last_response.body).to contain(/owner_name/)
                    expect(last_response.body).to contain(/repo_name/)
                end

                it "should display rating" do
                    expect(last_response.body).to have_selector('span', :content => "#{repo.rating}")
                end

                it "should display last commit info" do
                    expect(last_response.body).to contain(/sha-12345/)
                    expect(last_response.body).to contain(/joe bloggs/)
                    expect(last_response.body).to contain(/i fixed stuff/)
                end

                it "should display image with badge" do
                    expect(last_response.body).to have_xpath("//img[@src='/repos/owner_name/repo_name/badge.svg']")
                end

                context "with a last commit that has no message" do

                    let(:commit) do
                        HazCommitz::Commit.new("sha-12345", "joe bloggs", time_days_ago(7))
                    end

                    it "should not display any message or indication of" do
                        expect(last_response.body).not_to contain(/Message/)
                    end

                end

            end

            context "to badge url" do

                before { get("/repos/owner_name/repo_name/badge.svg") }

                it "should request repo info" do
                    HazCommitz::RepositoryService.any_instance.expects(:repo_with_last_commit).with('owner_name', 'repo_name').returns(repo)
                    get("/repos/owner_name/repo_name/badge.svg")
                end

                it "should return valid response" do
                    expect(last_response).to be_ok
                end

                it "should return svg content type" do
                    expect(last_response.content_type).to include('image/svg+xml')
                end

                it "should return an image"

                it "should set etag in response headers" do
                    expect(last_response['Etag']).not_to be_nil
                    expect(last_response['Etag']).not_to be_empty
                end

                it "should set caching directive" do
                    expect(last_response['Cache-Control']).to eq('no-cache, no-store, must-revalidate')
                end

            end

        end

        context "with a repo that does not exist" do

            before do
                HazCommitz::RepositoryService.any_instance.stubs(:repo_with_last_commit).raises(Octokit::NotFound)
            end

            context "to html url" do

                before { get("/repos/owner_name/repo_name") }

                it "should return not found status" do
                    expect(last_response.status).to eq(404)
                end

            end

            context "to badge url" do

                before { get("/repos/owner_name/repo_name/badge.svg") }

                it "should return not found status" do
                    expect(last_response.status).to eq(404)
                end

            end

        end

        context "with a repo that is unauthorised" do

            before do
                HazCommitz::RepositoryService.any_instance.stubs(:repo_with_last_commit).raises(Octokit::Unauthorized)
            end

            context "to html url" do

                before { get("/repos/owner_name/repo_name") }

                it "should return unauthorised status" do
                    expect(last_response.status).to eq(401)
                end

            end

            context "to badge url" do

                before { get("/repos/owner_name/repo_name/badge.svg") }

                it "should return unauthorised status" do
                    expect(last_response.status).to eq(401)
                end

            end

        end

        context "when the GitHub API rate limit is exceeded" do

            before do
                HazCommitz::RepositoryService.any_instance.stubs(:repo_with_last_commit).raises(Octokit::TooManyRequests)
            end

            context "to html url" do

                before { get("/repos/owner_name/repo_name") }

                it "should return service unavailble status" do
                    expect(last_response.status).to eq(503)
                end

            end

            context "to badge url" do

                before { get("/repos/owner_name/repo_name/badge.svg") }

                it "should return service unavailble status" do
                    expect(last_response.status).to eq(503)
                end

            end

        end

    end

    context "given a get request to add a repository" do

        before do
            get("/repos/new")
        end

        it "should return valid response" do
            expect(last_response).to be_ok
        end

        it "should render add view" do
            expect(last_response.body).to have_selector("div#new")
        end

    end

    context "given a post request for new repository" do

        context "given a request in valid format" do

            before do
                HazCommitz::RepositoryService.any_instance.stubs(:repo_with_last_commit).returns(repo)
                repo.stubs(:latest_commit).returns(commit)

                post '/repos/new', {"repo_path"=>"name/repo"}
            end

            let(:repo) do
                HazCommitz::GithubRepository.new('owner_name', 'repo_name')
            end

            let(:commit) do
                HazCommitz::Commit.new("sha-12345", "joe bloggs", time_days_ago(7), "i fixed stuff")
            end

            it "should return redirect" do
                expect(last_response).to be_redirect
            end

            it "should redirect to root view" do
                follow_redirect!

                # not interested if the response is valid, but need to stub repo service to avoid hitting api
                expect(last_request.url).to match('/repos/name/repo')
            end
        end

        context "with invalid data from form" do

            before { post '/repos/new', {"repo_path"=>"blah"} }

            it "should redirect to /add" do
                expect(last_response).to be_redirect
            end

            it "should redirect to add view" do
                follow_redirect!

                expect(last_request.url).to match('/repos/new')
            end

            it "should display flash message" do
                follow_redirect!

                expect(last_response.body).to contain(/Invalid repository format/)
            end

        end

    end

end