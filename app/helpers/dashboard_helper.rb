module DashboardHelper
  def date_fees(fee)
    if fee.payment_date
      "muted"
    elsif fee.expiration_date < Date.today
      "error"
    else
      "success"
    end
  end
end
