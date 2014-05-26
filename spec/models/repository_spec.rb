require 'spec_helper'

describe Repository do

  subject(:repo) { Repository.new('user-name', 'repo-name') }

  describe 'creating with params' do

    it 'should assign user-name' do
      expect(repo.owner).to eq('user-name')
    end

    it 'should assign repository name' do
      expect(repo.name).to eq('repo-name')
    end

    it 'should initialize with zero rating' do
      expect(repo.rating).to eq(0)
    end

    it 'should be valid' do
      expect(repo).to be_valid
    end

  end

  describe 'creating empty' do

    subject(:repo) { Repository.new }

    it 'should not be valid' do
      expect(repo).not_to be_valid
    end

  end

  describe '#path' do

    it 'should return path from user-name and repo-name' do
      expect(repo.path).to eq('user-name/repo-name')
    end

  end

  describe '#rate_with' do

    let(:rating_strategy) { mock }

    context 'with rating strategy' do

      it 'should ask rater for value' do
        rating_strategy.expects(:rate).with(repo).returns(1)
        repo.rate_with(rating_strategy)
      end

      it 'should apply rating to repository' do
        rating_strategy.stubs(:rate).returns(10)
        repo.rate_with(rating_strategy)
        expect(repo.rating).to eq(10)
      end

    end

  end

  describe '.new_from_path' do

    context 'when param is nil' do

      it 'should return nil' do
        expect(Repository.new_from_path(nil)).to be_nil
      end

    end

    context 'when param is has path components' do

      subject(:repo) { Repository.new_from_path('user-name/repo-name') }

      it 'should return instance' do
        expect(repo).not_to be_nil
      end

      it 'should assign user-name' do
        expect(repo.owner).to eq('user-name')
      end

      it 'should assign repository name' do
        expect(repo.name).to eq('repo-name')
      end

    end

    context 'when param has not enough path components' do

      it 'should return nil' do
        expect(Repository.new_from_path('foo')).to be_nil
      end

    end

    context 'when param has too many path components' do

      it 'should return nil' do
        expect(Repository.new_from_path('foo/bar/foo')).to be_nil
      end

    end

  end

end
