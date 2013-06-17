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
        address: row[3].to_s.split(',').join(', ')
      }

      client = save_instance(client, ::Client, attributes)

      Parser::Phone.new(row, client).parse
      Parser::Comment.new(row, client).parse
      Parser::Loan.new.save_loan(loan_id, client_id: client.id)
    end
  end
end
