module Summary
  LIMIT = 5
  
  def self.classes
    [Expired, CloseToExpire]
  end

  def filters
    zones + tags
  end 

  def zones
    current_user.zones.filter_by_loans(loans)
  end 

  def tags
    current_user.tags.filter_by_loans(loans)
  end
end
