module Summaries::Summary
  include ActiveSupport::NumberHelper

  LIMIT = 5
 
  def self.classes
    [Summaries::Expired, Summaries::CloseToExpire, Summaries::NotRenewed]
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

    rows.sort_by { |row| row[:value] }.reverse!.first(LIMIT)
  end

  def current_loans
    (filter ? loans.find_by_filter(filter) : loans).joins(:client).filtered_list(query)
  end

  def loans_sorted
    sorted(current_loans)
  end

  def loans_count
    current_loans.count
  end

  def loans_summary
    value(current_loans)
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
