module Fees::Delayed
  extend ActiveSupport::Concern

  included do
    scope :with_payment_day, -> { where("#{table_name}.payment_date IS NOT NULL") }
    scope :without_payment_day, -> { where("#{table_name}.payment_date IS NULL") }
  end

  module ClassMethods
    def filtered_list(query)
      query.present? ? magick_search(query) : all
    end

    def expire_before(date)
      where("#{table_name}.expiration_date < ?", date)
    end

    def expire_after(date)
      where("#{table_name}.expiration_date > ?", date)
    end
  end

  def expired?
    self.expiration_date < Date.today
  end

  # TODO: Refactor days calculations
  def late_average
    paid_fees = Fee.with_payment_day.where(loan_id: self.loan_id)
    unpaid_fees = Fee.without_payment_day.expire_before(Date.today).where(loan_id: self.loan_id)
    days = paid_fees_sum(paid_fees) + unpaid_fees_sum(unpaid_fees)
    days = Date.today - self.expiration_date.to_date if days == 0
    number_of_fees = paid_fees.count + unpaid_fees.count

    formal_delay(days, number_of_fees)
  end

  def paid_fees_sum(paid_fees)
    days = 0

    paid_fees.each do |fee|
      days += (fee.expiration_date.to_date - fee.payment_date.to_date)
    end

    days
  end

  def unpaid_fees_sum(unpaid_fees)
    days = 0

    unpaid_fees.each do |fee|
      days += (fee.expiration_date.to_date - Date.today)
    end

    days
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
