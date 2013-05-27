module LoansHelper
  def link_to_loan_info(loan)
    label = content_tag :span, '&#x2139;'.html_safe, class: 'iconic'

    link_to(
      label, loan,
      title: t('label.more_info'),
      data: {
        remote: true, show_tooltip: true, remove_target: "#loan-info-#{loan.to_param}"
      }
    )
  end

  def loan_category(loan)
    tag = loan.tagged_by_user.first
    content_tag(:span, tag.name, class: "badge badge-#{tag.category}") if tag
  end
end
