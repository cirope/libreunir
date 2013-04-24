module Parser
  class Loan < Base

    def line_save(row)
      if row_valid?(row)
        loan_id = row[0].gsub('PR0', '')
        attributes = { capital: row[2], payment: row[4] }

        Parser::Loan.save_loan(loan_id, attributes)
      end
    end

    def self.parse_loan(loan_id, client)
      save_loan(loan_id, client_id: client.id)
    end 

    def self.save_loan(loan_id, attributes)
      loan = ::Loan.find_by(loan_id: loan_id)
      
      if loan.try(:persisted?)
        loan.update_attributes(attributes)
        loan.touch
      else
        attributes.merge!(loan_id: loan_id)

        ::Loan.create(attributes)
      end
    end

    def row_valid?(row)
      return raise CSV::MalformedCSVError, 'Ivalid row' unless row[0].start_with?('PR0')
      
      true
    end
  end
end
