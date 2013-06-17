module DashboardHelper
  def link_to_loans(filter, zone, value, formatter)
    href = url_for [filter, zone, 'loans'].compact rescue nil

    value = case formatter
      when :currency
        number_to_currency value
      else
        value
    end

    href ? link_to(value, href) : value
  end
end
