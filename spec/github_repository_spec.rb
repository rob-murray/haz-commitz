require 'spec_helper'

describe HazCommitz::GithubRepository do

    subject(:repo) { HazCommitz::GithubRepository.new("user-name", "repo-name") }

    describe "creating" do

        it "should assign user-name" do
            expect(repo.owner).to eq("user-name")
        end

        it "should assign repository name" do
            expect(repo.name).to eq("repo-name")
        end

        it "should initialize with zero rating" do
            expect(repo.rating).to eq(0)
        end

    end

    describe "#path" do

        it "should return path from user-name and repo-name" do
            expect(repo.path).to eq("user-name/repo-name")
        end

    end

    describe "#rate_with" do

        let(:rating_strategy) { mock() }

        context "with rating strategy" do

            it "should ask rater for value" do
                rating_strategy.expects(:rate).with(repo).returns(1)
                repo.rate_with(rating_strategy)
            end

            it "should apply rating to repository" do
                rating_strategy.stubs(:rate).returns(10)
                repo.rate_with(rating_strategy)
                expect(repo.rating).to eq(10)
            end

        end

    end

end