class Expired
  include Summary

  attr_reader :current_user

  def initialize(current_user)
    @current_user = current_user
  end

  def headers
    [
      Zone.model_name.human(count: 0), 
      I18n.t("view.loans.expired"), 
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

  def action
    :expired
  end

  def formatter
    :currency
  end

  private
  
  def loans
    @current_user.loans.expired    
  end

  def value(loans)
    loans.sum('total_debt')
  end 
end
