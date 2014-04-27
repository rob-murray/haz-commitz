require 'spec_helper'

describe HazCommitz::RootController do
    include Webrat::Matchers

    context "given a request to the server root" do

        before(:each) do
            get("/")
        end

        it "should return valid response" do
            expect(last_response).to be_ok
        end

        it "should render root view" do
            expect(last_response.body).to have_selector("div#root")
        end

    end

    context "given a request to add a repository" do

        before(:each) do
            get("/add")
        end

        it "should return valid response" do
            expect(last_response).to be_ok
        end

        it "should render add view" do
            expect(last_response.body).to have_selector("div#add")
        end

    end

end