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
        concat ' '
        concat link_to('&#x2718;'.html_safe,
          [tag, loan.taggings.find_by(tag_id: tag.id)],
          data: {
            remote: true, method: :delete, confirm: t('messages.confirmation')
          }
        )
      end
    end

    tags.join(' ')
  end

  def show_phones(phones)
    phones.map do |phone|
      if phone.carrier.present?
        content_tag(:abbr, phone.phone, title: phone.carrier)
      else
        phone.phone
      end
    end.join(' - ').html_safe
  end
end
