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
    output = link_to(
      '-', toggle_done_schedule_path(schedule),
      data: { remote: true, method: :patch, toggle_schedule_done_link: true },
      class: 'hidden'
    )

    output + check_box_tag(
      'schedule', "mark_#{schedule.to_param}_as_done", schedule.done,
      class: 'margin-less', data: { toggle_schedule_done: schedule.to_param }
    )
  end

  def link_to_schedulable(schedule)
    label = schedule.schedulable.class.model_name.human(count: 1)
    label << " #{schedule.schedulable}"

    schedule.done ? label : link_to(label, schedule,  data: { remote: true })
  end
end
