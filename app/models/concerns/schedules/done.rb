module Schedules::Done
  extend ActiveSupport::Concern

  included do
    scope :done, -> { where(done: true) }
  end

  def toggle_done
    self.update_attribute(:done, !self.done) if self.doable?
  end

  def doable?
    !(self.done && self.past?)
  end

  def editable?
    !self.done
  end
end
