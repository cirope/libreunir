module Loans::Scopes
  extend ActiveSupport::Concern

  def find_tagging_by(tag)
    taggings.find_by(tag_id: tag.id)
  end

  module ClassMethods
    def expired
      where('canceled_at IS NULL AND expired_payments_count > ?', 0)
    end

    def not_renewed
      where.not(canceled_at: nil)
    end

    def close_to_expire
      where('canceled_at IS NULL AND progress IS NOT NULL')
    end

    def close_to_cancel
      where('payments_to_expire_count <= 2')
    end

    def sorted_by_total_debt
      order('total_debt DESC')
    end

    def sorted_by_progress
      order('progress DESC')
    end

    def sorted_by_canceled_at
      order('canceled_at DESC')
    end

    def find_by_filter(filter)
      case filter
        when Tag  then filter_by_tag(filter)
        when Zone then filter_by_zone(filter)
      end
    end

    def filter_by_zone(zone)
      where(zone_id: zone.id)
    end

    def filter_by_tag(tag)
      joins(:tags).where("#{Tag.table_name}.path && ARRAY[?]", tag.id)
    end
  end
end
