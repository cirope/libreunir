module Schedules::Reminders
  extend ActiveSupport::Concern

  included do
    attr_accessor :remind_me

    before_save :build_reminder
    after_update :update_reminder
  end

  def remind_me_default_value
    self.new_record? && self.remind_me.nil? || self.reminders.present?
  end

  def allow_remind_me?
    self.new_record? || !self.past? && self.reminders.all?(&:allow_destruction?)
  end

  private

  def build_reminder
    if build_reminder?
      self.reminders.build(remind_at: self.scheduled_at - delay, kind: 'email')
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

  def update_reminder
    if self.scheduled_at_changed?
      self.reminders.each { |r| r.update_attributes(remind_at: (self.scheduled_at - delay)) }
    end
  end

  def delay
    15.minutes
  end
end
