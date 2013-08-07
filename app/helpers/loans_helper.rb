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
    tags = []
    action = params[:action_name] || action_name

    loan.tags.each do |tag|
      tags << content_tag(:span, class: "tagging label label-#{tag.category}") do
        concat link_to truncate_tag_name(tag), [action, tag, 'loans']
        concat ' | '
        concat link_to('x',
          loan_tagging_path(loan, loan.find_tagging_by(tag), action_name: action),
          data: { remote: true, method: :delete, confirm: t('messages.confirmation') }
        )
      end
    end

    tags.join(' ')
  end

  def loan_progress(loan)
    progress = case loan.progress
      when 0..50   then 'progress-success'
      when 51..74  then 'progress-info'
      when 75..89  then 'progress-warning'
      when 90..100 then 'progress-danger'
    end

    content_tag(:div, class: "progress #{progress}") do
      content_tag(:div, "#{loan.progress}%", class: 'bar', style: "width: #{loan.progress}%;")
    end
  end

  def show_phone(phone)
    if phone
      if phone.carrier.present?
        content_tag(:abbr, phone.phone, title: phone.carrier)
      else
        phone.phone
      end
    end
  end

  def show_debt_percentage(loan)
    number_to_percentage(loan.total_debt.to_f * 100.0 / @total_debt) if @total_debt > 0
  end

  def show_delayed_at(loan)
    t('datetime.distance_in_words.x_days', count: (Date.today - loan.delayed_at).to_i) rescue ''
  end
end
