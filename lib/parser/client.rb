module Parser
  class Client < Base

    def line_save(row)
      if row_valid?(row)
        loan_id = row[0].gsub('PR0', '')
        client_name = row[1].split(',')

        client = ::Client.find_by(identification: row[2])

        attributes = {
          name: client_name[1].strip, 
          lastname: client_name[0].strip, 
          identification: row[2], 
          address: row[3], 
          phone: row[4]
        }

        if client.try(:persisted?)
          client.update_attributes(attributes)
          client.touch

          Parser::Loan.parse_loan(loan_id, client)
        else
          client = ::Client.create(attributes)

          Parser::Loan.parse_loan(loan_id, client)
          Parser::Comment.parse(row, client)
        end
      end
    end

    def row_valid?(row)
      return raise CSV::MalformedCSVError, 'Ivalid row' unless row[0].start_with?('PR0')

      true
    end
  end
end
