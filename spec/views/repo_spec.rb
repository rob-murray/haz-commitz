require 'rails_helper'

describe 'repository/show.html.erb', type: :view do
  let(:repo) do
    repo = Repository.from_owner_and_name('owner_name', 'repo_name')
    repo.add_commit(commit)
    repo
  end

  let(:commit) do
    Commit.build('sha-12345', 'joe bloggs', time_days_ago(7), 'i fixed stuff')
  end

  let(:rating) { "X" }

  before do
    assign(:repo, repo)
    assign(:letter_rating, rating)

    render
  end

  it 'displays repository information' do
    expect(rendered).to have_content(repo.owner)
    expect(rendered).to have_content(repo.name)
  end

  it 'displays repository rating' do
    expect(rendered).to have_selector('span', text: rating)
  end

  it 'should display last commit info' do
    expect(rendered).to have_content(commit.author_name)
    expect(rendered).to have_content(commit.sha.last(7))
    expect(rendered).to have_content(commit.date)
    expect(rendered).to have_content(commit.message)
  end

  it 'should display image with badge' do
    expect(rendered).to have_xpath("//img[@src='/repos/#{repo.owner}/#{repo.name}.svg']")
  end

  context 'with a last commit that has no message' do
    let(:commit) do
      Commit.build('sha-12345', 'joe bloggs', time_days_ago(7), '')
    end

    it 'should not display any message or indication of' do
      assign(:repo, repo)

      render

      expect(rendered).not_to have_content('Message')
    end
  end
end
