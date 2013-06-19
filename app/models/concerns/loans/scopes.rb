module Loans::Scopes
  extend ActiveSupport::Concern

  module ClassMethods
    def policy
      where("#{table_name}.days_overdue_average <= :days", days: 7)
    end

    def with_expiration
      where.not("#{table_name}.next_payment_expire_at" => nil)
    end

    def not_expired
      where("#{table_name}.expired_payments_count" => 0)
    end

    def expired
      where("#{table_name}.expired_payments_count > ?", 0)
    end

    def sorted_by_expiration
      order("#{table_name}.payments_to_expire_count ASC")
    end

    def find_by_filtered_loans(loans)
      where("#{table_name}.id IN (:loans_ids)", loans_ids: loans.map(&:id))
    end
  end
end
