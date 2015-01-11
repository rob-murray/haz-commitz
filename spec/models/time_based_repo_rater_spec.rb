require 'rails_helper'

describe TimeBasedRepoRater do
  subject { TimeBasedRepoRater.new }

  describe '#rate' do

    context 'invalid repo' do
      let(:repo) { nil }

      it 'should rate minimum value' do
        expect(subject.rate(repo)).to eq(0)
      end
    end

    context 'repo with invalid date' do
      let(:commit) { Commit.new('foo', 'joe bloggs', 'invalid date', '') }
      let(:repo) do
        repo = Repository.new('joe-bloggs', 'invalid-repo')
        repo.add_commit(commit)
        repo
      end

      it 'should rate minimum value' do
        expect(subject.rate(repo)).to eq(0)
      end

    end

    context 'repo with invalid date' do
      let(:commit) { Commit.new('foo', 'joe bloggs', nil, '') }
      let(:repo) do
        repo = Repository.new('joe-bloggs', 'invalid-repo')
        repo.add_commit(commit)
        repo
      end

      it 'should rate minimum value' do
        expect(subject.rate(repo)).to eq(0)
      end
    end

    context 'repo with commit within 1 day' do
      let(:commit) { Commit.new('foo', 'joe bloggs', Time.now, '') }
      let(:repo) do
        repo = Repository.new('joe-bloggs', 'repo-name')
        repo.add_commit(commit)
        repo
      end

      it 'should rate maximum value' do
        expect(subject.rate(repo)).to eq(10)
      end
    end

    context 'repo with commit within 1 week' do
      let(:commit) { Commit.new('foo', 'joe bloggs', time_days_ago(7), '') }
      let(:repo) do
        repo = Repository.new('joe-bloggs', 'repo-name')
        repo.add_commit(commit)
        repo
      end

      it 'should rate maximum value' do
        expect(subject.rate(repo)).to eq(10)
      end
    end

    context 'repo with commit within 1 month' do
      let(:commit) { Commit.new('foo', 'joe bloggs', time_days_ago(30), '') }
      let(:repo) do
        repo = Repository.new('joe-bloggs', 'repo-name')
        repo.add_commit(commit)
        repo
      end

      it 'should rate something high' do
        expect(subject.rate(repo)).to eq(8)
      end
    end

    context 'repo with commit within 3 months' do
      let(:commit) { Commit.new('foo', 'joe bloggs', time_months_ago(3), '') }
      let(:repo) do
        repo = Repository.new('joe-bloggs', 'repo-name')
        repo.add_commit(commit)
        repo
      end

      it 'should rate high-med' do
        expect(subject.rate(repo)).to eq(6)
      end
    end

    context 'repo with commit within 6 months' do
      let(:commit) { Commit.new('foo', 'joe bloggs', time_months_ago(6), '') }
      let(:repo) do
        repo = Repository.new('joe-bloggs', 'repo-name')
        repo.add_commit(commit)
        repo
      end

      it 'should rate low-med' do
        expect(subject.rate(repo)).to eq(4)
      end
    end

    context 'repo with commit within 12 months' do
      let(:commit) { Commit.new('foo', 'joe bloggs', time_months_ago(12), '') }
      let(:repo) do
        repo = Repository.new('joe-bloggs', 'repo-name')
        repo.add_commit(commit)
        repo
      end

      it 'should rate something low' do
        expect(subject.rate(repo)).to eq(2)
      end
    end

    context 'repo with commit over 12 months' do
      let(:commit) { Commit.new('foo', 'joe bloggs', time_months_ago(13), '') }
      let(:repo) do
        repo = Repository.new('joe-bloggs', 'repo-name')
        repo.add_commit(commit)
        repo
      end

      it 'should rate minimum value' do
        expect(subject.rate(repo)).to eq(1)
      end
    end
  end
end
