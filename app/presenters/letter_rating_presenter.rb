class LetterRatingPresenter
  def initialize(rating)
    @rating = rating
  end

  def letter
    case @rating
        when 1 then "F"
        when 2..3 then "E"
        when 4..5 then "D"
        when 6..7 then "C"
        when 8..9 then "B"
        when 10 then "A"
        else "None"
        end
  end
end
