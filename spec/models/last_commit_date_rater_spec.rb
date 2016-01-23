require 'rails_helper'

describe LastCommitDateRater do
  subject { described_class.new(repo) }

  describe '#rating' do
    context 'repo with invalid date' do
      let(:commit) { Commit.build('foo', 'joe bloggs', 'invalid date', '') }
      let(:repo) do
        repo = Repository.from_owner_and_name('joe-bloggs', 'invalid-repo')
        repo.add_commit(commit)
        repo
      end

      it 'should rate minimum value' do
        expect(subject.rating).to eq(0)
      end
    end

    context 'repo with invalid date' do
      let(:commit) { Commit.build('foo', 'joe bloggs', nil, '') }
      let(:repo) do
        repo = Repository.from_owner_and_name('joe-bloggs', 'invalid-repo')
        repo.add_commit(commit)
        repo
      end

      it 'should rate minimum value' do
        expect(subject.rating).to eq(0.0)
      end
    end

    context 'repo with commit within 1 day' do
      let(:commit) { Commit.build('foo', 'joe bloggs', Time.zone.now, '') }
      let(:repo) do
        Repository.from_owner_and_name('joe-bloggs', 'repo-name').tap do |r|
          r.add_commit(commit)
        end
      end

      it 'should rate maximum value' do
        expect(subject.rating).to eq(10)
      end
    end

    context 'repo with commit within 1 week' do
      let(:commit) { Commit.build('foo', 'joe bloggs', time_days_ago(7), '') }
      let(:repo) do
        Repository.from_owner_and_name('joe-bloggs', 'repo-name').tap do |r|
          r.add_commit(commit)
        end
      end

      it 'should rate maximum value' do
        expect(subject.rating).to eq(10)
      end
    end

    context 'repo with commit within 1 month' do
      let(:commit) { Commit.build('foo', 'joe bloggs', time_days_ago(30), '') }
      let(:repo) do
        Repository.from_owner_and_name('joe-bloggs', 'repo-name').tap do |r|
          r.add_commit(commit)
        end
      end

      it 'should rate something high' do
        expect(subject.rating).to eq(8)
      end
    end

    context 'repo with commit within 3 months' do
      let(:commit) { Commit.build('foo', 'joe bloggs', time_months_ago(3), '') }
      let(:repo) do
        Repository.from_owner_and_name('joe-bloggs', 'repo-name').tap do |r|
          r.add_commit(commit)
        end
      end

      it 'should rate high-med' do
        expect(subject.rating).to eq(6)
      end
    end

    context 'repo with commit within 6 months' do
      let(:commit) { Commit.build('foo', 'joe bloggs', time_months_ago(6), '') }
      let(:repo) do
        Repository.from_owner_and_name('joe-bloggs', 'repo-name').tap do |r|
          r.add_commit(commit)
        end
      end

      it 'should rate low-med' do
        expect(subject.rating).to eq(4)
      end
    end

    context 'repo with commit within 12 months' do
      let(:commit) { Commit.build('foo', 'joe bloggs', time_months_ago(12), '') }
      let(:repo) do
        Repository.from_owner_and_name('joe-bloggs', 'repo-name').tap do |r|
          r.add_commit(commit)
        end
      end

      it 'should rate something low' do
        expect(subject.rating).to eq(2)
      end
    end

    context 'repo with commit over 12 months' do
      let(:commit) { Commit.build('foo', 'joe bloggs', time_months_ago(13), '') }
      let(:repo) do
        Repository.from_owner_and_name('joe-bloggs', 'repo-name').tap do |r|
          r.add_commit(commit)
        end
      end

      it 'should rate minimum value' do
        expect(subject.rating).to eq(1)
      end
    end
  end
end
