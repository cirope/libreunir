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

  def loans_magick_path(options = {})
    options[:start] ||= Date.today

    case action_name
    when 'expired'
      expired_loans_path(options)
    when 'close_to_expire'
      close_to_expire_loans_path(options)
    end
  end

  def link_to_loan_date_filter(label, options = {})
    classes = ['btn']
    classes << 'disabled' if @filter.start == options[:start]

    link_to label, loans_magick_path(options), class: classes.join(' '), remote: true
  end
end
