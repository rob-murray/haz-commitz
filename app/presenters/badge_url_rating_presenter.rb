class BadgeUrlRatingPresenter
  BASE_URI = "http://img.shields.io/badge/".freeze
  SUBJECT = "Haz%20Commitz".freeze
  SEPARATOR = "-".freeze
  FORMAT = ".svg".freeze

  def initialize(rating)
    @rating = rating
  end

  def display
    status_colour_segment =  case @rating
        when 1 then '%3E%201%20year-red' # > 1 year
        when 2..3 then '%3C%201%20year-orange' # < 1 year
        when 4..5 then '%3C%206%20months-yellow' # < 6 months
        when 6..7 then '%3C%203%20months-yellowgreen' # < 3 months
        when 8..9 then '%3C%201%20month-brightgreen' # < 1 month
        when 10 then '%3C%201%20week-brightgreen' # < 1 week
        else 'None-red'
        end

    [BASE_URI, SUBJECT, SEPARATOR, status_colour_segment, FORMAT].join
  end
end
