module Fees
  module Delayed
    extend ActiveSupport::Concern

    included do
      scope :with_payment_day, -> { where('payment_date IS NOT NULL') }
      scope :without_payment_day, -> { where('payment_date IS NULL') }
    end

    module ClassMethods
      def filtered_list(query)
        query.present? ? magick_search(query) : all
      end

      def expired_before(date)
        where('expiration_date < ?', date)
      end
    end

    # TODO: Refactor days calculations
    def late_average
      days = 0
      payed_fees = self.class.with_payment_day.where(loan_id: self.loan_id)

      payed_fees.each do |fee|
        if fee.expiration_date && fee.payment_date
          days += (fee.expiration_date.to_date - fee.payment_date.to_date)
        end
      end

      unpayed_fees = self.class.without_payment_day.expired_before(Date.today).where(loan_id: self.loan_id)

      unpayed_fees.each do |fee|
        days += (fee.expiration_date.to_date - Date.today)
      end

      days = Date.today - self.expiration_date.to_date if days == 0
      number_of_fees = payed_fees.count + unpayed_fees.count

      formal_delay(days, number_of_fees)
    end

    def late_days
      expiration_date = self.expiration_date.try(:to_date)
      payment_date = self.payment_date.try(:to_date)

      if payment_date
        days = expiration_date - payment_date
      else
        if expiration_date > Date.today
          days = 0
        else
          days = expiration_date - Date.today
        end
      end

      formal_delay(days, 1)
    end

    def formal_delay(days, number_of_fees)
      if days < 0
        is = 'late'
        days = -days
      else
        is = 'in_time'
      end

      days = days / number_of_fees if number_of_fees > 0

      I18n.t("view.dashboard.#{is}", days: days.to_i, count: days.to_i)
    end
  end
end
