class CommitCountRater < FiveStar.base_rater
  rating_weight 0.6

  def description
    "This project has #{number_of_commits_in_words} in the past 6 months"
  end

  def rating
    unless repo.present? && repo.commits.any?
      return min_rating
    end

    # The higher the number of commits, the higher the rating
    #
    case number_of_commits
    when 0..5 then min_rating
    when 6..10 then 1
    when 11..15 then 2
    when 16..25 then 4
    when 26..36 then 6
    when 37..50 then 8
    else max_rating
    end
  end

  private

  def number_of_commits
    repo.commits.size
  end

  def repo
    rateable
  end

  def number_of_commits_in_words
    ActionController::Base.helpers.pluralize(number_of_commits, 'commit')
  end
end
