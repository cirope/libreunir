module Parser
  class Payment < Base

    def line_save(row)
      if row_valid?(row)
        loan_id = row[0].gsub('PR0', '')

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

        if payment.try(:persisted?)
          payment.update_attributes(attributes)
          payment.touch
        else
          attributes.merge!(loan_id: loan_id)

          ::Payment.create(attributes)
        end
      end
    end

    def row_valid?(row)
      return raise CSV::MalformedCSVError, 'Invalid row' unless row[0].start_with?('PR0')
      
      true
    end
  end
end
