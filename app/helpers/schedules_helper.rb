module SchedulesHelper
  def link_to_new_schedule(schedulable)
    label = content_tag :span, '&#xe079;'.html_safe, class: 'iconic'

    link_to(
      label, new_polymorphic_path([schedulable, Schedule]),
      title: t('label.scheduler'),
      data: { remote: true, show_tooltip: true }
    )
  end

  def show_mark_schedule_as_done_check_box(schedule)
    check_box_tag(
      'schedule_ids[]', schedule.to_param, false,
      class: 'margin-less', disabled: !schedule.doable?, id: nil,
      data: { mark_done: schedule.done }
    )
  end

  def link_to_schedulable(schedule)
    label = schedule.label

    schedule.done ? label : link_to(label, schedule,  data: { remote: true })
  end

  def link_to_cancel_schedule
    data = { dismiss: 'modal' }
    data = { show_siblings: '[data-object-id]' } unless @modal

    link_to t('label.cancel'), '#', data: data
  end

  def show_remind_me_schedule_checkbox(form)
    @schedule.remind_me = @schedule.remind_me_default_value

    form.input(
      :remind_me, as: :boolean, wrapper: :checkbox,
      input_html: { disabled: !@schedule.allow_remind_me? }
    )
  end

  def show_tags(schedulable)
    if schedulable.respond_to?(:tags)
      tags = []
      schedulable.tags.each do |tag|
        tags << content_tag(:span, truncate_tag_name(tag), class: "tagging label label-#{tag.category}")
      end
      tags.join(' ')
    end
  end

  def show_owner(schedule)
    if (owner_id = schedule.versions.first.whodunnit) && owner_id != selected_user.id
      content_tag :span, "(#{User.find_by(id: owner_id)})", class: 'muted'
    end
  end
end
