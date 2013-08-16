module Parser
  class Client < Base
    def process_row(row)
      loan_id = row[0].gsub('PR0', '').to_i

      client = first_or_create(
        name: row[1],
        identification: row[2],
        address: row[3]
      )
      Parser::Phone.new(row, client).parse

      loan = Parser::Loan.new.save_loan(loan_id, client_id: client.id)
      Parser::Comment.new(row, loan).parse
    end

    def first_or_create(attributes)
      client_name = attributes[:name].split(',')
      client = ::Client.find_by(identification: attributes[:identification])

      attributes = {
        name: client_name[1].strip, 
        lastname: client_name[0].strip, 
        identification: attributes[:identification]
      }

      if attributes[:address].to_s.split(',').present?
        attributes.merge!(address: attributes[:address]) 
      end

      save_instance(client, ::Client, attributes)
    end
  end
end
