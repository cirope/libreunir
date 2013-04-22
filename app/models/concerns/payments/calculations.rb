module Payments::Calculations
  extend ActiveSupport::Concern

  def expired?
    self.expiration_date < Date.today
  end
end
