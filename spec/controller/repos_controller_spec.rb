require 'spec_helper'

describe HazCommitz::ReposController do
    include Webrat::Matchers

    context "given a request with repos path" do

        before(:each) do
            get("/repos")
        end

        it "should return redirect" do
            expect(last_response).to be_redirect
        end

        it "should redirect to root view" do
            follow_redirect!

            expect(last_response).to be_ok
            expect(last_request.url).to match('/')
        end

    end

    context "given an html request to with repo owner and repo" do

        before(:each) do
            HazCommitz::RepositoryService.any_instance.stubs(:repo_with_last_commit).returns(repo)

            repo.stubs(:latest_commit).returns(commit)

            get("/repos/owner_name/repo_name")
        end

        let(:repo) do
            HazCommitz::GithubRepository.new('owner_name', 'repo_name')
        end

        let(:commit) do
            HazCommitz::Commit.new("sha-12345", "joe bloggs", time_days_ago(7), "i fixed stuff")
        end

        context "given a valid owner name and repo name" do

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

        end

        context "given a last commit with no message" do

            let(:commit) do
                HazCommitz::Commit.new("sha-12345", "joe bloggs", time_days_ago(7))
            end

            it "should not display any message or indication of" do
                expect(last_response.body).not_to contain(/Message/)
            end

        end

        context "given a repo name that does not exist" do

            before(:each) do
                HazCommitz::RepositoryService.any_instance.stubs(:repo_with_last_commit).raises(Octokit::NotFound)
                get("/repos/owner_name/repo_name")
            end

            it "should return not found status" do
                expect(last_response.status).to eq(404)
            end

        end

        context "given a repo that is unauthorised" do

            before(:each) do
                HazCommitz::RepositoryService.any_instance.stubs(:repo_with_last_commit).raises(Octokit::Unauthorized)
                get("/repos/owner_name/repo_name")
            end

            it "should return unauthorised status" do
                expect(last_response.status).to eq(401)
            end

        end

        context "given github api rate limit exceeded" do

            before(:each) do
                HazCommitz::RepositoryService.any_instance.stubs(:repo_with_last_commit).raises(Octokit::TooManyRequests)
                get("/repos/owner_name/repo_name/badge.svg")
            end

            it "should return service unavailble status" do
                expect(last_response.status).to eq(503)
            end

        end

    end

    context "given a badge request for repo owner and repo" do

        before(:each) do
            HazCommitz::RepositoryService.any_instance.stubs(:repo_with_last_commit).returns(repo)

            repo.stubs(:latest_commit).returns(commit)

            get("/repos/owner_name/repo_name/badge.svg")
        end

        let(:repo) do
            HazCommitz::GithubRepository.new('owner_name', 'repo_name')
        end

        let(:commit) do
            HazCommitz::Commit.new("sha-12345", "joe bloggs", time_days_ago(7), "i fixed stuff")
        end

        context "given a valid owner name and repo name" do

            it "should return valid response" do
                expect(last_response).to be_ok
            end

            it "should return svg content type" do
                expect(last_response.content_type).to include('image/svg+xml')
            end

            it "should return image"

            it "should set etag in response headers" do
                expect(last_response['Etag']).not_to be_nil
                expect(last_response['Etag']).not_to be_empty
            end

            it "should set caching directive" do
                expect(last_response['Cache-Control']).to eq('no-cache, no-store, must-revalidate')
            end

        end

        context "given a repo name that does not exist" do

            before(:each) do
                HazCommitz::RepositoryService.any_instance.stubs(:repo_with_last_commit).raises(Octokit::NotFound)
                get("/repos/owner_name/repo_name/badge.svg")
            end

            it "should return not found status" do
                expect(last_response.status).to eq(404)
            end

        end

        context "given a repo that is unauthorised" do

            before(:each) do
                HazCommitz::RepositoryService.any_instance.stubs(:repo_with_last_commit).raises(Octokit::Unauthorized)
                get("/repos/owner_name/repo_name/badge.svg")
            end

            it "should return unauthorised status" do
                expect(last_response.status).to eq(401)
            end

        end

        context "given github api rate limit exceeded" do

            before(:each) do
                HazCommitz::RepositoryService.any_instance.stubs(:repo_with_last_commit).raises(Octokit::TooManyRequests)
                get("/repos/owner_name/repo_name/badge.svg")
            end

            it "should return service unavailble status" do
                expect(last_response.status).to eq(503)
            end

        end

    end

end