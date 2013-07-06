module Summary
  LIMIT = 5
  
  def self.classes
    [Expired, CloseToExpire]
  end

  def headers
    [   
      Zone.model_name.human(count: 0), 
      I18n.t("view.loans.#{action}"), 
      Loan.model_name.human(count: 0)
    ]   
  end 

  def rows
    rows = []

    filters.each do |filter|
      row = {}
      loans_filtered = loans.find_by_filter(filter)

      row[:filter] = filter
      row[:value]  = value(loans_filtered)
      row[:amount] = loans_filtered.count

      rows << row 
    end 

    rows.sort_by { |row| row[:value] }.reverse!.first(Summary::LIMIT)
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
