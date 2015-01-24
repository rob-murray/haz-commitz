require 'rails_helper'

RSpec.describe NewRepositoryForm do
  subject { NewRepositoryForm.new(path: repository_path) }

  describe 'validating' do
    context 'given valid data' do
      let(:repository_path) { 'rob-murray/haz-commitz' }

      it 'is valid' do
        expect(subject).to be_valid
      end

      it 'returns owner name' do
        expect(subject.owner).to eq('rob-murray')
      end

      it 'returns name' do
        expect(subject.name).to eq('haz-commitz')
      end
    end

    context 'given invalid data' do
      let(:repository_path) { 'foo' }

      it 'is valid' do
        expect(subject).not_to be_valid
      end

      it 'has error on path' do
        subject.valid?

        expect(subject.errors[:path]).not_to be_empty
      end
    end

    context 'given empty data' do
      let(:repository_path) { nil }

      it 'is valid' do
        expect(subject).not_to be_valid
      end

      it 'has error on path' do
        subject.valid?

        expect(subject.errors[:path]).not_to be_empty
      end
    end
  end
end
