module Parser
  class Product < Base
    def process_row(row)
      loan_id = row[0].gsub('PR0', '').to_i
      loan = ::Loan.find_by(loan_id: loan_id)

      attributes = { 
        delayed_at: row[3], 
        expired_payments_count: row[95], 
        payments_to_expire_count: row[96], 
        next_payment_expire_at: row[97]
      }

      save_instance(loan, { loan_id: loan_id }, ::Loan, attributes)
    end
    
    def row_valid?(row)
      return raise CSV::MalformedCSVError, 'Ivalid row' unless row[0].start_with?('PR0')
      
      true
    end
  end
end
