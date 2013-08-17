module Parser
  class Client < Base
    def process_row(row)
      loan_id = row[0].gsub('PR0', '').to_i

      client = first_or_create(
        name: row[1],
        identification: row[2],
        address: row[3]
      )
      client_phones(row, client)

      loan = Parser::Loan.new.save_loan(loan_id, client_id: client.id)
      Parser::Comment.new(row, loan).parse
    end

    def first_or_create(attrs)
      ::Client.find_by(identification: attrs[:identification]) || client_create(attrs)
    end

    def client_create(attrs)
      client_name = attrs[:name].split(',')

      attributes = {
        name: client_name[1].strip,
        lastname: client_name[0].strip,
        identification: attrs[:identification]
      }

      if attrs[:address].to_s.split(',').present?
        attributes.merge!(address: attrs[:address])
      end

      save_instance(nil, ::Client, attributes)
    end

    def client_phones(row, client)
      if client
        attributes = {
          tel1: row[4], tel2: row[8], tel3: row[9], tel4: row[10], tel5: row[11],
          cel1_code: row[12], cel1: row[13], cel1_com: row[14], cel1_radio: row[15],
          cel2_code: row[16], cel2: row[17], cel2_com: row[18], cel2_radio: row[19]
        }

        Parser::Phone.new(attributes, client).parse
      end
    end
  end
end
