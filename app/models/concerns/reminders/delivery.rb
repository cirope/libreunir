module Reminders::Delivery
  extend ActiveSupport::Concern

  included do
    scope :upcoming, -> {
      where(
        [
          "#{table_name}.remind_at <= :date",
          "#{table_name}.notified   = :false"
        ].join(' AND '),
        { date: 5.minutes.from_now, false: false }
      )
    }
  end

  module ClassMethods
    def send_reminders
      upcoming.find_each do |reminder|
        ReminderWorker.perform_at(reminder.remind_at, reminder.id)
      end
    end
  end
end
