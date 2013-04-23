module Loans::Scopes
  extend ActiveSupport::Concern

  included do
    scope :pending, -> {
      includes(:payments).where("#{Payment.table_name}.paid_at" => nil)
    }
  end

  module ClassMethods
    def expire_before(date)
      includes(:payments).where("#{Payment.table_name}.expired_at < ?", date)
    end

    def expire_after(date)
      includes(:payments).where("#{Payment.table_name}.expired_at > ?", date)
    end
  end
end
