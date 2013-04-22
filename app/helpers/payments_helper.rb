module PaymentsHelper
  def link_to_payment_info(payment)
    label = content_tag :span, '&#x2139;'.html_safe, class: 'iconic'

    link_to(
      label, payment,
      id: "payment-info-link-#{payment.to_param}",
      title: t('label.more_info'),
      data: {
        remote: true, show_tooltip: true, remove_target: "#payment-info-#{payment.to_param}"
      }
    )
  end

  def payments_magick_path(options = {})
    options[:start] ||= Date.today

    case action_name
    when 'expired'
      expired_payments_path(options)
    when 'close_to_expire'
      close_to_expire_payments_path(options)
    end
  end

  def link_to_payment_date_filter(label, options = {})
    classes = ['btn']
    classes << 'disabled' if @filter.start == options[:start]

    link_to label, payments_magick_path(options), class: classes.join(' '), remote: true
  end
end
