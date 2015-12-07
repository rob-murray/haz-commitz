class StarCountRater < FiveStar.base_rater
  rating_weight 1.0

  def description
    "This project has #{number_of_stars_in_words}"
  end

  def rating
    unless repository.present?
      return min_rating
    end

    # The higher the number of stars, the higher the rating
    #
    case number_of_stars
    when 0..1 then min_rating
    when 2..5 then 1
    when 6..11 then 2
    when 12..20 then 3
    when 21..39 then 4
    when 40..60 then 5
    when 61..99 then 6
    when 100..200 then 7
    when 201..500 then 8
    when 501..1000 then 9
    else max_rating
    end
  end

  private

  def repository
    rateable
  end

  def number_of_stars
    repository.stars
  end

  def number_of_stars_in_words
    ActionController::Base.helpers.pluralize(number_of_stars, 'star')
  end
end
