module Loans::Scopes
  extend ActiveSupport::Concern

  module ClassMethods
    def policy
      where("#{table_name}.days_overdue_average <= ?", 7)
    end

    def expired
      where("#{table_name}.expired_payments_count > ?", 0)
    end

    def sorted_by_total_debt
      order("#{Loan.table_name}.total_debt DESC")
    end

    def sorted_by_progress
      order("#{table_name}.progress DESC")
    end

    def find_by_loans(loans)
      where("#{table_name}.id" => loans.ids)
    end

    def filter_by_tag(tag)
      joins(:tags).where("#{Tag.table_name}.path && ARRAY[?]", tag.id)
    end
  end
end
