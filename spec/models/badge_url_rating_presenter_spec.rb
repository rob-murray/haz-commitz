require 'rails_helper'

describe BadgeUrlRatingPresenter do
  subject { BadgeUrlRatingPresenter.new(rating) }

  context 'given a maximum rating' do
    let(:rating) { 10 }

    it 'should return a url for best rating' do
      expect(subject.display).to match /brightgreen/
    end
  end

  context 'given a rating of 9' do
    let(:rating) { 9 }

    it 'should return a url for rating' do
      expect(subject.display).to match /brightgreen/
    end
  end

  context 'given a rating of 8' do
    let(:rating) { 8 }

    it 'should return a url for rating' do
      expect(subject.display).to match /brightgreen/
    end
  end

  context 'given a rating of 7' do
    let(:rating) { 7 }

    it 'should return a url for rating' do
      expect(subject.display).to match /yellowgreen/
    end
  end

  context 'given a rating of 6' do
    let(:rating) { 6 }

    it 'should return a url for rating' do
      expect(subject.display).to match /yellowgreen/
    end
  end

  context 'given a rating of 5' do
    let(:rating) { 5 }

    it 'should return a url for rating' do
      expect(subject.display).to match /yellow/
    end
  end

  context 'given a rating of 4' do
    let(:rating) { 4 }

    it 'should return a url for rating' do
      expect(subject.display).to match /yellow/
    end
  end

  context 'given a rating of 3' do
    let(:rating) { 3 }

    it 'should return a url for rating' do
      expect(subject.display).to match /orange/
    end
  end

  context 'given a rating of 2' do
    let(:rating) { 2 }

    it 'should return a url for rating' do
      expect(subject.display).to match /orange/
    end
  end

  context 'given a rating of 1' do
    let(:rating) { 1 }

    it 'should return a url for rating' do
      expect(subject.display).to match /red/
    end
  end

  context 'given a minimum rating' do
    let(:rating) { 0 }

    it 'should return a url for lowest rating' do
      expect(subject.display).to match /red/
    end
  end
end
