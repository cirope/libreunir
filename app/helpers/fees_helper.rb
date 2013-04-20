module FeesHelper
  def link_to_fee_info(fee)
    label = content_tag :span, '&#x2139;'.html_safe, class: 'iconic'

    link_to(
      label, fee,
      id: "fee-info-link-#{fee.to_param}",
      title: t('label.more_info'),
      data: {
        remote: true, show_tooltip: true, remove_target: "#fee-info-#{fee.to_param}"
      }
    )
  end

  def fees_magick_path(options = {})
    options[:start] ||= Date.today

    case action_name
    when 'expired'
      expired_fees_path(options)
    when 'close_to_expire'
      close_to_expire_fees_path(options)
    end
  end

  def link_to_fee_date_filter(label, options = {})
    classes = ['btn']
    classes << 'disabled' if @filter.start == options[:start]

    link_to label, fees_magick_path(options), class: classes.join(' '), remote: true
  end
end
