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

  # content_tag vs render partial
  def show_phones(loan)
    content_tag :ul do
      if loan.phones.present?
        loan.phones.each do |phone|
          concat(content_tag(:li, " #{[phone.carrier, phone.phone].join(' - ')} " ))
        end
      else
        concat(content_tag(:li, content_tag(:span, '-')))
      end
    end
  end

  def show_last_comments(loan)
    content_tag :ul do
      loan.last_comments.each do |comment|
        concat(
          content_tag(:li) do
            concat(" [#{l(comment.created_at.to_date)}] ")
            concat(" #{comment.user}: #{comment.comment} ")
          end
        )
      end
    end
  end

  def show_schedules(loan)
    content_tag :ul do
      loan.schedules.reverse_order.each do |schedule|
        concat(
          content_tag(:li) do
            concat(" [#{l(schedule.created_at.to_date)}] ")
            concat(" #{schedule.description} (#{schedule.user})")
            if schedule.notes.present?
              show_notes(schedule)
              concat(tag(:br))
            end
          end
        )
      end
    end
  end

  def show_notes(schedule)
    concat(content_tag(:h6, Note.model_name.human(count: 0)))
    concat(
      content_tag(:ul) do
        schedule.notes.each do |note|
          concat(
            content_tag(:li) do
              concat(note.note)
              concat(" (#{note.user}) ")
              concat("[#{l note.created_at.to_date}]")
            end
          )
        end
      end
    )
  end
end
