module DateHelper
  DAYS_IN_MONTH = 30

  def time_days_ago(days)
    (DateTime.now - days).to_time
  end

  def time_months_ago(months)
    time_days_ago(months * DAYS_IN_MONTH)
  end
end
