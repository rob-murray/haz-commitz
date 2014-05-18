require 'spec_helper'

describe Commit do

  describe 'creating instance' do

    context 'with all valid data' do

      subject(:commit) { Commit.new('abcdefg', 'joe bloggs', DateTime.now, 'a brilliant fix') }

      it 'should store commit sha' do
        expect(commit.sha).to eq('abcdefg')
      end

      it 'should store commit author name' do
        expect(commit.author_name).to eq('joe bloggs')
      end

      it 'should store commit date' do
        expect(commit.date.to_s).to eq(DateTime.now.to_s)
      end

      it 'should store commit message' do
        expect(commit.message).to eq('a brilliant fix')
      end

    end

    context 'without commit message' do

      subject(:commit) { Commit.new('abcdefg', 'joe bloggs', DateTime.now) }

      it 'creates instance' do
        expect(commit).not_to be_nil
      end

      it 'should store empty message' do
        expect(commit.message).to eq('')
      end

    end

  end

end
