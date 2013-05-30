module Loans::Scopes
  extend ActiveSupport::Concern

  included do
    scope :sorted_by_expiration, -> { order("#{table_name}.payments_to_expire_count ASC") }
    scope :expired, -> { where("#{table_name}.expired_payments_count > ?", 0) }
    scope :not_expired, -> { where("#{table_name}.expired_payments_count" => 0) }
    scope :with_expiration, -> { where.not("#{table_name}.next_payment_expire_at" => nil) }
    scope :policy, -> { where("#{table_name}.days_overdue_average <= :days", days: 7) }
  end
end
