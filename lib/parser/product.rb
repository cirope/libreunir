module Parser
  class Product < Base
    def process_row(row)
      loan_id = row[0].gsub('PR0', '').to_i
      loan = ::Loan.find_by(loan_id: loan_id)

      attributes = { 
        loan_id: loan_id,
        delayed_at: row[3], 
        total_debt: row[8],
        payments_count: row[20],
        expired_payments_count: row[95], 
        payments_to_expire_count: row[96], 
        next_payment_expire_at: row[97]
      }

      loan = save_instance(loan, ::Loan, attributes)
      
      save_instance(loan, ::Loan, { days_overdue_average: overdue_average(loan) })
    end
    
    private

    def overdue_average(loan)
      payments = loan.payments.map(&:days_overdue).compact

      payments.reduce(:+) / payments.count if payments.count > 0
    end
  end
end
