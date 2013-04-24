module Parser
  class Payment < Base
    def process_row(row)
      loan_id = row[0].gsub('PR0', '').to_i

      user = ::User.find_by(username: row[21])
      loan = ::Loan.find_by(loan_id: loan_id)
      payment = ::Payment.find_by(loan_id: loan.try(:id), number: row[1])

      attributes = {
        number: row[1], 
        expired_at: row[2], 
        paid_at: row[16],
        amount_paid: row[17], 
        total_paid: row[41], 
        user_id: user.try(:id)
      }

      save_instance(payment, { loan_id: loan_id }, ::Payment, attributes)
    end

    def row_valid?(row)
      return raise CSV::MalformedCSVError, 'Invalid row' unless row[0].start_with?('PR0')
      
      true
    end
  end
end
