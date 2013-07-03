module Filters
  extend ActiveSupport::Concern

  def loans_count(loans)
    self.loans.where(id: loans.ids).count
  end
  
  def expired(loans)
    self.loans.where(id: loans.ids).expired.count
  end

  def close_to_expire(loans)
    self.loans.where(id: loans.ids).policy.count
  end

  def total_debt(loans)
    self.loans.where(id: loans.ids).sum('total_debt')
  end
end
