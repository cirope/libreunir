module Loans::Scopes
  extend ActiveSupport::Concern

  included do
    default_scope -> { order("#{table_name}.next_payment_expire_at DESC") }
    scope :expired, -> { where("#{table_name}.expired_payments_count > ?", 0) }
    scope :not_expired, -> { where("#{table_name}.expired_payments_count" => 0) }
  end

  module ClassMethods
    def expire_before(date)
      where("#{table_name}.next_payment_expire_at < ?", date)
    end

    def expire_on_or_after(date)
      where("#{table_name}.next_payment_expire_at >= ?", date)
    end
  end
end
