require 'spec_helper'

describe HazCommitz::BadgeUrlRatingPresenter do

    context "given a maximum rating" do

        subject(:badge_url) { HazCommitz::BadgeUrlRatingPresenter.new(10) }

        it "should return a url for best rating" do
            expect(badge_url.display).to eq("http://img.shields.io/badge/Haz%20Commitz-1%20week-brightgreen.svg")
        end

    end

    context "given a rating of 9" do

        subject(:badge_url) { HazCommitz::BadgeUrlRatingPresenter.new(9) }

        it "should return a url for rating" do
            expect(badge_url.display).to eq("http://img.shields.io/badge/Haz%20Commitz-1%20months-brightgreen.svg")
        end

    end

    context "given a rating of 8" do

        subject(:badge_url) { HazCommitz::BadgeUrlRatingPresenter.new(8) }

        it "should return a url for rating" do
            expect(badge_url.display).to eq("http://img.shields.io/badge/Haz%20Commitz-1%20months-brightgreen.svg")
        end

    end

    context "given a rating of 7" do

        subject(:badge_url) { HazCommitz::BadgeUrlRatingPresenter.new(7) }

        it "should return a url for rating" do
            expect(badge_url.display).to eq("http://img.shields.io/badge/Haz%20Commitz-3%20months-yellowgreen.svg")
        end

    end

    context "given a rating of 6" do

        subject(:badge_url) { HazCommitz::BadgeUrlRatingPresenter.new(6) }

        it "should return a url for rating" do
            expect(badge_url.display).to eq("http://img.shields.io/badge/Haz%20Commitz-3%20months-yellowgreen.svg")
        end

    end

    context "given a rating of 5" do

        subject(:badge_url) { HazCommitz::BadgeUrlRatingPresenter.new(5) }

        it "should return a url for rating" do
            expect(badge_url.display).to eq("http://img.shields.io/badge/Haz%20Commitz-6%20months-yellow.svg")
        end

    end

    context "given a rating of 4" do

        subject(:badge_url) { HazCommitz::BadgeUrlRatingPresenter.new(4) }

        it "should return a url for rating" do
            expect(badge_url.display).to eq("http://img.shields.io/badge/Haz%20Commitz-6%20months-yellow.svg")
        end

    end

    context "given a rating of 3" do

        subject(:badge_url) { HazCommitz::BadgeUrlRatingPresenter.new(3) }

        it "should return a url for rating" do
            expect(badge_url.display).to eq("http://img.shields.io/badge/Haz%20Commitz-1%20year-orange.svg")
        end

    end

    context "given a rating of 2" do

        subject(:badge_url) { HazCommitz::BadgeUrlRatingPresenter.new(2) }

        it "should return a url for rating" do
            expect(badge_url.display).to eq("http://img.shields.io/badge/Haz%20Commitz-1%20year-orange.svg")
        end

    end

    context "given a rating of 1" do

        subject(:badge_url) { HazCommitz::BadgeUrlRatingPresenter.new(1) }

        it "should return a url for rating" do
            expect(badge_url.display).to eq("http://img.shields.io/badge/Haz%20Commitz-1%20year-red.svg")
        end

    end

    context "given a minimum rating" do

        subject(:badge_url) { HazCommitz::BadgeUrlRatingPresenter.new(0) }

        it "should return a url for lowest rating" do
            expect(badge_url.display).to eq("http://img.shields.io/badge/Haz%20Commitz-None-red.svg")
        end

    end


end