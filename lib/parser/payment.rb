module Parser
  class Payment < Base
    def process_row(row)
      loan_id = row[0].gsub('PR0', '').to_i

      user = ::User.find_by(username: row[21])
      loan = ::Loan.find_by(loan_id: loan_id)
      payment = ::Payment.find_by(loan_id: loan.try(:id), number: row[1])

      attributes = {
        loan_id: loan.try(:id),
        number: row[1],
        days_overdue: days_overdue(row[2], row[16]),
        expired_at: row[2], 
        capital: row[4],
        additional: row[14],
        paid_at: row[16],
        amount_paid: row[17], 
        total_paid: row[41], 
        user_id: user.try(:id)
      }

      save_instance(payment, ::Payment, attributes)
    end

    def days_overdue(expired_row, paid_row)
      expired_at = Date.parse(expired_row)
      paid_at = Time.zone.parse(paid_row)

      if expired_at.past? && !paid_at
        (Date.today - expired_at).to_i
      elsif paid_at
        overdue = (paid_at.to_date - expired_at).to_i 
        
        overdue < 0 ? 0 : overdue
      end
    end
  end
end
