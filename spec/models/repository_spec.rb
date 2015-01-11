require 'rails_helper'

describe Repository do
  subject { Repository.new('user-name', 'subject-name') }

  describe 'creating with params' do

    it 'should assign user-name' do
      expect(subject.owner).to eq('user-name')
    end

    it 'should assign subjectsitory name' do
      expect(subject.name).to eq('subject-name')
    end

    it 'should initialize with zero rating' do
      expect(subject.rating).to eq(0)
    end

    it 'should be valid' do
      expect(subject).to be_valid
    end

    it 'should not have any commits' do
      expect(subject.commits).to be_empty
    end

    it 'should not have a last commit' do
      expect(subject.latest_commit).to be_nil
    end
  end

  describe 'creating empty' do
    subject { Repository.new }

    it 'should not be valid' do
      expect(subject).not_to be_valid
    end
  end

  describe '#path' do

    it 'should return path from user-name and subject-name' do
      expect(subject.path).to eq('user-name/subject-name')
    end
  end

  describe 'adding commits' do
    let(:commit1) { Commit.new('abcdefg', 'joe bloggs', DateTime.now, '') }
    let(:commit2) { Commit.new('zzzzzzz', 'a guy', DateTime.now, '') }

    it 'should add one commit' do
      expect {
        subject.add_commit(commit1)
      }.to change{subject.commits.count}.from(0).to(1)
    end

    it 'should not add nil' do
      expect {
        subject.add_commit(nil)
      }.not_to change{subject.commits.count}
    end

    context 'with many commits' do
      before do
        subject.add_commit(commit1)
        subject.add_commit(commit2)
      end

      it 'should add many commits' do
        expect {
          subject.add_commit(commit1)
          subject.add_commit(commit2)
        }.to change{subject.commits.count}.by(2)
      end

      it 'should add in order' do
        commits = subject.commits
        expect(commits.first).to eq(commit1)
        expect(commits.last).to eq(commit2)
      end

      it 'should return latest_commit as the last commit' do
        expect(subject.latest_commit).to eq(commit2)
      end

      it 'should return the latest commit date' do
        expect(subject.latest_commit_date).to eq(commit2.date)
      end

      it 'should sort commits in date order'
    end
  end

  describe '#rate_with' do
    let(:rating_strategy) { double('rating_strategy') }

    context 'with rating strategy' do

      it 'should ask rater for value' do
        expect(rating_strategy).to receive(:rate).with(subject).and_return(1)

        subject.rate_with(rating_strategy)
      end

      it 'should apply rating to Repository' do
        allow(rating_strategy).to receive(:rate).and_return(10)

        subject.rate_with(rating_strategy)
        expect(subject.rating).to eq(10)
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
      subject { Repository.new_from_path('user-name/subject-name') }

      it 'should return instance' do
        expect(subject).not_to be_nil
      end

      it 'should assign user-name' do
        expect(subject.owner).to eq('user-name')
      end

      it 'should assign subjectsitory name' do
        expect(subject.name).to eq('subject-name')
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
