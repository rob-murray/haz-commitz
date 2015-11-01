class BadgeUrlRatingPresenter
  BASE_URI = "https://img.shields.io/badge/".freeze
  SUBJECT = "Haz%20Commitz".freeze
  SEPARATOR = "-".freeze
  FORMAT = ".svg?style=flat".freeze

  def initialize(rating)
    @rating = rating
  end

  def display
    status_colour_segment =  case rating
        when 1 then "%s-red" % rating_letter
        when 2..3 then "%s-orange" % rating_letter
        when 4..5 then "%s-yellow" % rating_letter
        when 6..7 then "%s-yellowgreen" % rating_letter
        when 8..9 then "%s-brightgreen" % rating_letter
        when 10 then "%s-brightgreen" % rating_letter
        else "None-red"
        end

    [BASE_URI, SUBJECT, SEPARATOR, status_colour_segment, FORMAT].join
  end

  private

  attr_reader :rating

  def rating_letter
    LetterRatingPresenter.new(rating).letter
  end
end
