require_relative 'repo_rater'

class TimeBasedRepoRater < RepoRater.rating_klass
  def rate
    time_now = Time.zone.now
    return min if repo.nil?

    last_commit_time = repo.latest_commit_date

    if last_commit_time.nil? || !last_commit_time.is_a?(Time) # catch when not Time object?
      return min
    end

    rating = case (time_now.to_date - last_commit_time.to_date).round
             when 0..7 then max
             when 8..30 then 8
             when 31..90 then 6
             when 91..180 then 4
             when 181..365 then 2
             when 366..Float::INFINITY then 1
             else min
             end

    rating
  end
end
