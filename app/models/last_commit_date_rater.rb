class LastCommitDateRater < FiveStar.base_rater
  rating_weight 0.4

  def description
    "The last commit on this project was #{last_commit_date_in_words}"
  end

  def rating
    unless repo.present? && last_commit_date.present? && last_commit_date.is_a?(Time)
      return min_rating
    end

    # The more recent the commit date, the higher the rating on no specific scale
    #
    case (time_now.to_date - last_commit_date.to_date).round
    when 0..7 then max_rating
    when 8..30 then 8
    when 31..90 then 6
    when 91..180 then 4
    when 181..365 then 2
    when 366..Float::INFINITY then 1
    else min_rating
    end
  end

  private

  def repo
    rateable
  end

  def last_commit_date
    repo.latest_commit_date
  end

  def time_now
    Time.zone.now
  end

  def last_commit_date_in_words
    if last_commit_date.present?
      format "%s (%s ago)", last_commit_date.to_formatted_s(:long), ActionController::Base.helpers.time_ago_in_words(last_commit_date)
    else
      "-"
    end
  end
end
