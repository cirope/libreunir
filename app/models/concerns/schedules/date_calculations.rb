module Schedules::DateCalculations
  extend ActiveSupport::Concern

  included do
    scope :upcoming_or_undone, -> {
      where(
        [
          "#{table_name}.scheduled_at BETWEEN :start AND :end",
          "#{table_name}.done = :false"
        ].join(' OR '),
        start: Time.now.at_beginning_of_day,
        end: 10.days.from_now.at_end_of_day,
        false: false
      )
    }
  end

  def past?
    self.scheduled_at < Time.now
  end

  module ClassMethods
    def count_by_days
      utc_offset = Time.zone.utc_offset
      operator = utc_offset > 0 ? '+' : '-'
      utc_corrector = "#{operator} interval '#{utc_offset.abs} seconds'"

      group("DATE_TRUNC('day', #{table_name}.scheduled_at #{utc_corrector})").count
    end

    def for_date(date)
      where(
        "#{table_name}.scheduled_at BETWEEN ? AND ?",
        date.at_beginning_of_day, date.at_end_of_day
      )
    end
  end
end
