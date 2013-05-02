module Schedules::DefaultDate
  extend ActiveSupport::Concern

  included do
    after_initialize :set_current_datetime
  end

  def set_current_datetime 
    self.scheduled_at ||= Time.zone.now
  end
end
