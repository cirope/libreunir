module Parser
  class Client < Base
    def process_row(row)
      loan_id = row[0].gsub('PR0', '').to_i
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
        client.without_versioning do
          client.update_attributes(attributes)
          client.touch
        end
      else
        client = ::Client.create(attributes)
        Parser::Comment.parse(row, client)
      end

      Parser::Loan.new.save_loan(loan_id, client_id: client.id)
    end

    def row_valid?(row)
      return raise CSV::MalformedCSVError, 'Ivalid row' unless row[0].start_with?('PR0')

      true
    end
  end
end
