module Parser
  class Loan < Base
    def process_row(row)
      loan_id = row[0].gsub('PR0', '').to_i
      attributes = { capital: row[2], payment: row[4] }

      save_loan(loan_id, attributes)
    end

    def save_loan(loan_id, attributes)
      loan = ::Loan.find_by(loan_id: loan_id)
      
      save_instance(loan, { loan_id: loan_id }, ::Loan, attributes)
    end

    def row_valid?(row)
      return raise CSV::MalformedCSVError, 'Ivalid row' unless row[0].start_with?('PR0')
      
      true
    end
  end
end
