namespace :debtors do
  desc 'Move to collectors'
  task move_to_collectors: :environment do
    ::Loan.current.find_each do |l|
      payment = l.payments.where(paid_at: nil).order('number ASC').try(:first)
      if payment && payment.expired_at <= (Date.today - 1.month).midnight
        l.update(debtor: true)
      else
        l.update(debtor: false)
      end
    end
  end
end
