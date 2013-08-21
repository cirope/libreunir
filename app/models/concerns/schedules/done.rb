module Schedules::Done
  extend ActiveSupport::Concern

  included do
    scope :done, -> { where(done: true) }
  end

  module ClassMethods
    def past
      where('done IS FALSE AND scheduled_at < ?', Time.now)
    end

    def future
      where('done IS FALSE AND scheduled_at > ?', Time.now)
    end
  end

  def mark_as_done
    self.update_attribute(:done, true) if self.doable?
  end

  def mark_as_pending
    self.update_attribute(:done, false) if self.pendentable?
  end

  def doable?
    !(self.done && self.past?)
  end

  def pendentable?
    self.done && !self.past?
  end

  def editable?
    !self.done
  end
end
