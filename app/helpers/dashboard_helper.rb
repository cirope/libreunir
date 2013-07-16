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

  def show_filter(filter)
    case filter
    when Tag
      content_tag(:span, truncate_tag_name(filter), class: "tagging badge badge-#{filter.category}")
    else
      truncate_tag_name(filter)
    end
  end
end
