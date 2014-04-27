require "date"
require_relative "repo_rater"

module HazCommitz
    class TimeBasedRepoRater < RepoRater

        def rate(github_repo)
            rating = MIN
            time_now = DateTime.now

            return MIN if github_repo.nil?

            last_commit_time = github_repo.latest_commit.date # fix

            if last_commit_time.nil? || !last_commit_time.is_a?(Time) # catch when not Time object?
                return MIN
            end

            rating = case (time_now - last_commit_time.to_datetime).round
                     when 1..7 then MAX
                     when 8..30 then 8
                     when 31..90 then 6
                     when 91..180 then 4
                     when 181..365 then 2
                     when 366..Float::INFINITY then 1
                     end

            rating
        end

    end
end