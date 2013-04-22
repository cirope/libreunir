module Payments::Calculations
  extend ActiveSupport::Concern

  def expired?
    self.expired_at < Date.today
  end
end
