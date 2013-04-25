module LoansHelper
  def link_to_loan_info(loan)
    label = content_tag :span, '&#x2139;'.html_safe, class: 'iconic'

    link_to(
      label, loan,
      id: "loan-info-link-#{loan.to_param}",
      title: t('label.more_info'),
      data: {
        remote: true, show_tooltip: true, remove_target: "#loan-info-#{loan.to_param}"
      }
    )
  end
end
