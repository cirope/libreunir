module Payments::Calculations
  extend ActiveSupport::Concern

  def expired?
    self.expiration < Date.today
  end
end
