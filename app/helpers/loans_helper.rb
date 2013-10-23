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
      tags << render('loans/tag', loan: loan, tag: tag, action: action)
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

  def show_debt_percentage(loan)
    number_to_percentage(loan.total_debt.to_f * 100.0 / @total_debt) if @total_debt > 0
  end

  def show_distance_in_words(delayed_at)
    t('datetime.distance_in_words.x_days', count: (Date.today - delayed_at).to_i) rescue ''
  end

  def show_schedule(loan)
    user = current_user.collector? ? current_user : selected_user
    if schedule = loan.closest_schedule(user)
      render 'loans/schedule', loan: loan, schedule: schedule
    end
  end

  def show_client_info(loan)
    content_tag(:abbr, loan.client, title: loan.segment)
  end

  def show_phones(loan)
    phones = []
    if loan.phones.present?
      loan.phones.each do |phone|
        phones << content_tag(:li, [phone.carrier, phone.phone].compact.join(' - '))
      end
    else
      return content_tag(:li, '-')
    end

    phones.join().html_safe
  end

  def show_payments_summary(loan)
    "#{loan.payments_count} (#{payments_paid(loan)}, #{payments_expired(loan)}, #{payments_to_expire(loan)})"
  end

  def interest_header
    content_tag(
      :abbr, payment_text('interest'),
      title: "#{payment_text('interest')} + #{payment_text('insurance')} + #{payment_text('tax')}"
    )
  end

  def show_expire_at(loan)
    if loan.delayed_at
      content_tag(:span, l(loan.delayed_at), class: 'text-error')
    elsif loan.next_payment_expire_at
      content_tag(:span, l(loan.next_payment_expire_at))
    end
  end

  private
    def payments_paid(loan)
      payments_paid_count =
        loan.payments_count - (loan.expired_payments_count + loan.payments_to_expire_count)

      "#{payments_paid_count} #{Loan.human_attribute_name('payments_paid_count')}"
    end

    def payments_expired(loan)
      "#{loan.expired_payments_count} #{Loan.human_attribute_name('expired_payments_count')}"
    end

    def payments_to_expire(loan)
      "#{loan.payments_to_expire_count} #{Loan.human_attribute_name('payments_to_expire_count')}"
    end

    def payment_text(attr)
      Payment.human_attribute_name(attr)
    end
end
