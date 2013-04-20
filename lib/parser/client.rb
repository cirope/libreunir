module Parser
  class Client < Base

    def line_save(row)
      if row_valid?(row)
        product_id = row[0].gsub('PR0', '').to_i

        attributes = {
          name: row[1], identification: row[2], product_id: product_id
        }

        client = ::Client.create(attributes)

        if client.persisted?
          Parser::Address.new(row, client).parse
          Parser::Phone.new(row, client).parse
          Parser::Call.new(row, client).parse
        end
      end
    end

    def row_valid?(row)
      if !row[0].start_with?('PR0')
        return raise CSV::MalformedCSVError, 'Ivalid row'
      end

      true
    end
  end
end
