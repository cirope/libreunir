module Parser
  class Loan < Base
    def process_row(row)
      loan_id = row[0].gsub('PR0', '').to_i
      attributes = { capital: row[2], payment: row[4] }

      save_loan(loan_id, attributes)
    end

    def save_loan(loan_id, attributes)
      loan = ::Loan.find_by(loan_id: loan_id)
      attributes.merge!(loan_id: loan_id)
      
      save_instance(loan, ::Loan, attributes)
    end
  end
end
