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
        days += (fee.expiration_date.to_date - fee.payment_date.to_date)
      end
      number_of_fees = fees.count ? 1 : fees.count

      formal_delay(days, number_of_fees)
    end

    def late_days
      expiration_date = self.expiration_date.try(:to_date) || 0
      payment_date = self.payment_date.try(:to_date) || 0

      days = expiration_date-payment_date
      days = days.is_a?(Date) ? 0 : days

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
