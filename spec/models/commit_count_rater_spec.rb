require 'rails_helper'

describe CommitCountRater do
  subject { CommitCountRater.new(repo) }

  describe '#rating' do
    context 'invalid repo' do
      let(:repo) { nil }

      it 'should rate minimum value' do
        expect(subject.rating).to eq(0)
      end
    end

    context 'repo with no commits' do
      let(:repo) do
        Repository.from_owner_and_name('joe-bloggs', 'invalid-repo')
      end

      it 'should rate minimum value' do
        expect(subject.rating).to eq(0)
      end
    end

    context 'repo with less than 10 commits' do
      let(:repo) do
        Repository.from_owner_and_name('joe-bloggs', 'invalid-repo').tap do |r|
          8.times do
            r.add_commit("commit")
          end
        end
      end

      it 'should rate something low' do
        expect(subject.rating).to eq(1)
      end
    end

    context 'repo with 100 commits' do
      let(:repo) do
        Repository.from_owner_and_name('joe-bloggs', 'invalid-repo').tap do |r|
          100.times do
            r.add_commit("commit")
          end
        end
      end

      it 'should rate maximum value' do
        expect(subject.rating).to eq(10)
      end
    end
  end
end
