require_relative 'repo_rater'

class CommitCountRater < RepoRater.rating_klass

  def self.description
    "The number of commits in the past 6 months"
  end

  def rate(repo)
    return min if repo.nil?

    unless repo.commits.any?
      return min
    end

    rating = case repo.commits.size
             when 0..5 then max
             when 6..10 then 8
             when 11..15 then 6
             when 16..25 then 4
             when 26..36 then 2
             when 37..50 then 1
             else min
             end

    rating
  end
end
