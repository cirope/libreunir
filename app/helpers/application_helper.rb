module ApplicationHelper
  def title
    [t('app_name'), @title].compact.join(' | ')
  end

  def show_menu_link(options = {})
    name = t("menu.#{options[:name]}")
    classes = []

    classes << 'active' if [*options[:controllers]].include?(controller_name)

    content_tag(
      :li, link_to(name, options[:path]),
      class: (classes.empty? ? nil : classes.join(' '))
    )
  end

  def show_button_dropdown(main_action, extra_actions = [], options = {})
    if extra_actions.blank?
      main_action
    else
      out = ''.html_safe

      out << render(
        partial: 'shared/button_dropdown', locals: {
          main_action: main_action, extra_actions: extra_actions
        }
      )
    end
  end

  def pagination_links(objects, params = nil)
    pagination_links = will_paginate objects,
      inner_window: 1, outer_window: 1, params: params,
      renderer: BootstrapPaginationHelper::LinkRenderer,
      class: 'pagination pagination-right'
    page_entries = content_tag(
      :blockquote,
      content_tag(
        :small,
        page_entries_info(objects),
        class: 'page-entries hidden-desktop pull-right'
      )
    )

    content_tag :div, raw(pagination_links.to_s + page_entries), class: 'pagination-container'
  end

  def iconic_link(icon, *args)
    options = args.extract_options!

    options['class'] ||= 'iconic'
    options['title'] ||= 'iconic'
    options['data-show-tooltip'] ||= true

    link_to icon, *args, options
  end

  def link_to_new(*args)
    options = args.extract_options!

    options['title'] ||= t('label.new')

    iconic_link '&#xe008;'.html_safe, *args, options
  end

  def link_to_show(*args)
    options = args.extract_options!

    options['title'] ||= t('label.show')

    iconic_link '&#xe074;'.html_safe, *args, options
  end

  def link_to_edit(*args)
    options = args.extract_options!

    options['title'] ||= t('label.edit')

    iconic_link '&#x270e;'.html_safe, *args, options
  end

  def link_to_destroy(*args)
    options = args.extract_options!

    options['title'] ||= t('label.delete')
    options['method'] ||= :delete
    options['data-confirm'] ||= t('messages.confirmation')

    iconic_link '&#xe05a;'.html_safe, *args, options
  end
end
