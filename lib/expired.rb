class Expired
  include Summary

  attr_reader :current_user

  def initialize(current_user)
    @current_user = current_user
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
