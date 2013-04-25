module Loans::Scopes
  extend ActiveSupport::Concern

  included do
    default_scope -> { order("#{table_name}.next_payment_expire_at DESC") }
    scope :expired, -> { where("#{table_name}.expired_payments_count > ?", 0) }
    scope :not_expired, -> { where("#{table_name}.expired_payments_count" => 0) }
  end
end
