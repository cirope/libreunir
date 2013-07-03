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

    loan.tags.each do |tag|
      tags << content_tag(:span, class: "tagging badge badge-#{tag.category}") do
        concat tag.name
        concat ' | '
        concat link_to('x', [tag, loan.find_tagging_by(tag)],
          data: { remote: true, method: :delete, confirm: t('messages.confirmation') }
        )
      end
    end

    tags.join(' ')
  end

  def loan_progress(loan)
    progress = case loan.progress
      when 0..50   then 'progress-success'
      when 51..80  then 'progress-info'
      when 81..89  then 'progress-warning'
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
end
