
module HazCommitz
    class BadgeUrlRatingPresenter

        def initialize(rating)
            @rating = rating
        end

        def display
            badge_url = case @rating
                        when 1 then 'http://img.shields.io/badge/Haz%20Commitz-1%20year-red.svg'
                        when 2..3 then 'http://img.shields.io/badge/Haz%20Commitz-1%20year-orange.svg'
                        when 4..5 then 'http://img.shields.io/badge/Haz%20Commitz-6%20months-yellow.svg'
                        when 6..7 then 'http://img.shields.io/badge/Haz%20Commitz-3%20months-yellowgreen.svg'
                        when 8..9 then 'http://img.shields.io/badge/Haz%20Commitz-1%20months-brightgreen.svg'
                        when 10 then 'http://img.shields.io/badge/Haz%20Commitz-1%20week-brightgreen.svg'
                        else 'http://img.shields.io/badge/Haz%20Commitz-None-red.svg'
                        end

            badge_url
        end

    end
end