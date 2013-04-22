module Parser
  class Client < Base

    def line_save(row)
      if row_valid?(row)
        product_id = row[0].gsub('PR0', '').to_i
        client_name = row[1].split(',')

        client = ::Client.find_by_identification(row[2])

        attributes = {
          name: client_name[1].strip, lastname: client_name[0].strip, 
          identification: row[2], address: row[3], phone: row[4]
        }

        if client.try(:persisted?)
          client.update_attributes(attributes)

          Parser::Product.parse_product(product_id, client)
        else
          client = ::Client.create(attributes)

          Parser::Product.parse_product(product_id, client)
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
