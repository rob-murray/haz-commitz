require 'rails_helper'

describe RepoRater do
  let(:commit) { Commit.build('foo', 'joe bloggs', 'invalid date', '') }
  let(:repo) do
    repo = Repository.from_owner_and_name('joe-bloggs', 'invalid-repo')
    repo.add_commit(commit)
    repo
  end
  subject { RepoRater.new(repo) }

  describe "#rate" do
    context "with no rating klasses" do
      it "returns minimum" do
        expect(subject.rate).to be_zero
      end
    end

    context "with one rating klass provided" do
      let(:rater) { double('Rater', rate: 5) }
      before do
        subject.rate_with(rater)
      end

      it "returns rating value" do
        expect(subject.rate).to eq(5)
      end
    end

    context "with two rating klasses provided" do
      let(:rater_1) { double('Rater', rate: 5) }
      let(:rater_2) { double('Rater', rate: 9) }

      before do
        subject.rate_with([rater_1, rater_2])
      end

      it "returns mean average value" do
        expect(subject.rate).to eq(7)
      end
    end
  end
end
