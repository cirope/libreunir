module Loans::Scopes
  extend ActiveSupport::Concern

  def find_tagging_by(tag)
    taggings.find_by(tag_id: tag.id)
  end

  module ClassMethods
    def expired
      not_canceled.where('expired_payments_count > 0')
    end

    def not_renewed
      where.not(canceled_at: nil)
    end

    def close_to_expire
      not_canceled.where.not(progress: nil)
    end

    def close_to_cancel
      not_canceled.debtor.where('expired_payments_count + payments_to_expire_count <= ?', 2)
    end

    def capital
      not_canceled.debtor
    end

    def prevision
      start, finish = (Date.today - 90).midnight, (Date.today - 60).midnight

      not_canceled.debtor.where(delayed_at: start..finish)
    end

    def not_canceled
      where(canceled_at: nil)
    end

    def debtor
      where('debtor IS TRUE AND progress IS NOT NULL')
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
      joins(:tags).where("#{Tag.table_name}.id" => tag.path_ids)
    end
  end
end
