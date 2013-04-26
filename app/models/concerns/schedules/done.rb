module Schedules::Done
  extend ActiveSupport::Concern

  included do
    scope :done, -> { where(done: true) }
  end

  def toggle_done
    self.done = !self.done
  end
end
