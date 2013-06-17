module Common::Filters
  extend ActiveSupport::Concern

  def loans_count(loans)
    self.loans.where(id: loans.map(&:id)).count
  end
  
  def expired(loans)
    self.loans.where(id: loans.map(&:id)).expired.count
  end

  def close_to_expire(loans)
    self.loans.where(id: loans.map(&:id)).not_expired.with_expiration.policy.count
  end

  def total_debt(loans)
    self.loans.where(id: loans.map(&:id)).sum('total_debt')
  end
end
