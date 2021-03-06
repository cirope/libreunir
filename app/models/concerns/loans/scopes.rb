module Loans::Scopes
  extend ActiveSupport::Concern

  def find_tagging_by(tag)
    taggings.find_by(tag_id: tag.id)
  end

  def expired_payments
    payments.where('paid_at IS NULL AND expired_at < ?', Date.today).order('number ASC')
  end

  module ClassMethods
    def expired
      current.no_debtor.where('expired_payments_count > 0')
    end

    def not_renewed
      where(state: 'not_renewed')
    end

    def close_to_expire
      current.no_debtor.where.not(progress: nil)
    end

    def close_to_cancel
      current.debtor.where('expired_payments_count + payments_to_expire_count <= ?', 2)
    end

    def capital
      current.debtor
    end

    def prevision
      start, finish = (Date.today - 90).midnight, (Date.today - 60).midnight

      current.debtor.where(delayed_at: start..finish)
    end

    def not_canceled
      where(canceled_at: nil)
    end

    def debtor
      where(debtor: true)
    end

    def no_debtor
      where(debtor: false)
    end

    def current
      where(state: 'current')
    end

    def history
      where(state: 'history')
    end

    def standby
      where(state: 'standby')
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
      # tag.subtree_ids dont work
      joins(:tags).where("#{Tag.table_name}.id" => tag.subtree.pluck('id'))
    end
  end
end
