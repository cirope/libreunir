module Parser
  class Loan < Base

    def line_save(row)
      if row_valid?(row)

        loan_id = row[0].gsub('PR0', '')
        loan = ::Loan.find_by_loan_id(loan_id)

        attributes = { capital: row[2], payment: row[4] }

        if loan.try(:persisted?)
          loan.update_attributes(attributes)
        else
          attributes.merge!(loan_id: row[0])

          ::Loan.create(attributes)
        end
      end
    end

    def self.parse_loan(loan_id, client)
      loan = ::Loan.find_by_loan_id(loan_id)

      if loan.try(:persisted?)
        loan.update_attributes(client_id: client.id)
      else
        ::Loan.create(loan_id: loan_id, client_id: client.id)
      end
    end 

    def row_valid?(row)
      return raise CSV::MalformedCSVError, 'Ivalid row' unless row[0].start_with?('PR0')
      
      true
    end
  end
end
