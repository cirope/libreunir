module Parser
  class Client < Base

    def line_save(row)
      if row_valid?(row)
        product_id = row[0].gsub('PR0', '').to_i
        client = row[1].split(',')

        attributes = {
          name: client[1].strip, lastname: client[0].strip, identification: row[2],
          address: row[3], phone: row[4]
        }

        client = ::Client.create(attributes)

        if client.persisted?
          Parser::Product.create_product(product_id, client)
          Parser::Comment.parse(row, client)
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
