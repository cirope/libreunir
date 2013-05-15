module Schedules::Reminders
  extend ActiveSupport::Concern

  included do
    attr_accessor :remind_me

    before_save :build_reminder
  end

  def remind_me_default_value
    self.new_record? && self.remind_me.nil? || self.reminders.present?
  end

  private

  def build_reminder
    if build_reminder?
      self.reminders.build(remind_at: self.scheduled_at - 15.minutes, kind: 'email')
    elsif remove_reminder?
      self.reminders.clear
    end
  end

  def build_reminder?
    (self.remind_me == '1' || self.remind_me == true) && self.reminders.empty?
  end

  def remove_reminder?
    self.remind_me == '0' || self.remind_me == false
  end
end
