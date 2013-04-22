module Payments::Scopes
  extend ActiveSupport::Concern

  included do
    scope :pending, -> { where("#{table_name}.paid_at" => nil) }
  end

  module ClassMethods
    def filtered_list(query)
      query.present? ? magick_search(query) : all
    end

    def expire_before(date)
      where("#{table_name}.expired_at < ?", date)
    end

    def expire_after(date)
      where("#{table_name}.expired_at > ?", date)
    end
  end
end
