module Loans::Payments
  extend ActiveSupport::Concern

  included do
    has_many :payments, dependent: :destroy
  end

  def oldest_pending_payment_expiration
    self.payments.pending.order('expired_at DESC').pluck('expired_at').first
  end
end
