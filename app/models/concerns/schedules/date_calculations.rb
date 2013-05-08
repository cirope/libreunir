module Schedules::DateCalculations
  extend ActiveSupport::Concern

  def past?
    self.scheduled_at < Time.now
  end

  module ClassMethods
    def for_date_of_month(date)
      utc_offset = Time.zone.utc_offset
      operator = utc_offset > 0 ? '+' : '-'
      utc_corrector = "#{operator} interval '#{utc_offset.abs} seconds'"

      where(
        "#{table_name}.scheduled_at BETWEEN ? AND ?", 
        date.at_beginning_of_month, date.at_end_of_month
      ).pluck("TO_CHAR(#{table_name}.scheduled_at #{utc_corrector}, 'yyyy-mm-dd')")
    end

    def for_date_of_day(date)
      where(
        "#{table_name}.scheduled_at BETWEEN ? AND ?",
        date.at_beginning_of_day, date.at_end_of_day
      )
    end
  end
end
