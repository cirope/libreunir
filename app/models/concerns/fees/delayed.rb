module Fees
  module Delayed
    extend ActiveSupport::Concern

    module ClassMethods
      def filtered_list(query)
        query.present? ? magick_search(query) : all
      end
    end

    # TODO: Refactor days calculations
    def late_average
      fees = self.class.where("payment_date IS NOT NULL AND loan_id = ?", self.loan_id)
      days = 0
      fees.each do |fee|
        if fee.expiration_date && fee.payment_date
          days += (fee.expiration_date.to_date - fee.payment_date.to_date)
        else
          days += Date.today - fee.expiration_date.to_date
        end
      end

      if days == 0
        days = Date.today - self.expiration_date.to_date
      end

      number_of_fees = fees.count

      formal_delay(days, number_of_fees)
    end

    def late_days
      expiration_date = self.expiration_date.try(:to_date) || 0
      payment_date = self.payment_date.try(:to_date)

      if payment_date
        days = expiration_date-payment_date
      else
        if Date.today < expiration_date
          days = 0
        else
          days = self.expiration_date.to_date-Date.today.to_date
        end
      end

      formal_delay(days, 1)
    end

    def formal_delay(days, number_of_fees)
      if days < 0
        formal = 'late'
        days = -days
      else
        formal = 'in_time'
      end

      I18n.t("view.dashboard.#{formal}", days: days.to_i, count: days.to_i)
    end
  end
end
