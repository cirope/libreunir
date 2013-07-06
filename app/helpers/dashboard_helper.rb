module DashboardHelper
  def link_to_loans(action, filter, value, formatter)
    href = url_for [action, filter, 'loans'].compact rescue nil

    value = case formatter
      when :currency
        number_to_currency value
      else
        value
    end

    href ? link_to(value, href) : value
  end
end
