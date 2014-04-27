require_relative 'badge_url_rating_presenter'

module HazCommitz
    class ErrorBadgeUrl < BadgeUrlRatingPresenter

        def display
            'http://img.shields.io/badge/Haz%20Commitz-error-lightgrey.svg'
        end

    end
end