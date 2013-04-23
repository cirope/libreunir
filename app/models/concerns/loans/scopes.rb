module Loans::Scopes
  extend ActiveSupport::Concern

  included do
    scope :pending, -> {
      includes(:payments).where("#{table_name}.delayed_at" => nil)
    }
  end

  module ClassMethods
    def expire_before(date)
      includes(:payments).where("#{table_name}.delayed_at < ?", date)
    end

    def expire_after(date)
      includes(:payments).where("#{table_name}.delayed_at > ?", date)
    end
  end
end
