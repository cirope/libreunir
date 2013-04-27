module Schedules::Done
  extend ActiveSupport::Concern

  included do
    scope :done, -> { where(done: true) }
  end

  def toggle_done
    self.update_attribute(:done, !self.done) unless self.past?
  end

  def doable?
    !(self.done && self.past?)
  end
end
