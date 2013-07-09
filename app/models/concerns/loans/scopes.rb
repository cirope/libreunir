module Loans::Scopes
  extend ActiveSupport::Concern

  def find_tagging_by(tag)
    taggings.find_by(tag_id: tag.id)
  end

  module ClassMethods
    def policy
      where("#{table_name}.days_overdue_average <= ?", 7)
    end

    def expired
      where("#{table_name}.expired_payments_count = ?", 1)
    end

    def sorted_by_total_debt
      order("#{table_name}.total_debt DESC")
    end

    def sorted_by_progress
      order("#{table_name}.progress DESC")
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
