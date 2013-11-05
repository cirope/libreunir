module Parser
  class Product < Base
    def process_row(row)
      loan_id = row[0].gsub('PR0', '').to_i
      loan = ::Loan.find_by(loan_id: loan_id)

      attributes = { 
        loan_id: loan_id,
        delayed_at: row[3], 
        total_debt: row[5],
        payments_count: row[8],
        expired_payments_count: expired_payments_count(loan),
        payments_to_expire_count: payments_to_expire_count(loan),
        next_payment_expire_at: row[12],
        state: 'current'
      }

      loan = save_instance(loan, ::Loan, attributes)
      
      save_instance(
        loan, ::Loan,
        {
          progress: percentage_progress(loan),
          days_overdue_average: overdue_average(loan)
        }
      )
    end
    
    private

    def expired_payments_count(loan)
      loan.payments.where('paid_at IS NULL AND expired_at < ?', Date.today).count if loan
    end

    def payments_to_expire_count(loan)
      loan.payments.where('paid_at IS NULL AND expired_at >= ?', Date.today).count if loan
    end

    def percentage_progress(loan)
      if loan.payments_count > 0
        (((loan.payments_count - expired(loan)) / loan.payments_count.to_f) * 100).round
      end
    end

    def expired(loan)
      loan.expired_payments_count + loan.payments_to_expire_count
    end

    def overdue_average(loan)
      loan.payments.where.not(days_overdue: nil).average(:days_overdue).try(:round)
    end
  end
end
