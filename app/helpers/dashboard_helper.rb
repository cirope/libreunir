module DashboardHelper
  def link_to_loans(action, filter, value, value_formatted)
    href = url_for [action, filter, 'loans'].compact rescue nil

    href ? link_to(value_formatted, href) : value_formatted
  end

  def show_filter(filter)
    case filter
    when Tag
      content_tag(
        :span, truncate_tag_name(filter), 
        class: "tagging label label-#{filter.category}"
      )
    else
      truncate_tag_name(filter)
    end
  end
end
