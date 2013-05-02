module ClientsHelper
  def link_to_client_info(client)
    label = content_tag :span, '&#x2139;'.html_safe, class: 'iconic'

    link_to(
      label, client,
      title: t('label.more_info'),
      data: {
        remote: true, show_tooltip: true, remove_target: "#client-info-#{client.to_param}"
      }
    )
  end
end
