module Parser
  class Client < Base

    HEADERS = [
      'productoid', 'cliente', 'cuil', 'DomicilioLaboral', 
      'TelefPrincip', 'Contacto1', 'Contacto2', 'Contacto3'
    ] 
  
    def line_save(row)
      if row_valid?(row)
        product_id = row[0].gsub('PR0', '').to_i

        client = ::Client.where(product_id: product_id).first_or_create(
          name: row[1], identification: row[2], product_id: product_id
        )

        if client.persisted?
          create_address(client, row)
          create_phones(client, row)
          create_calls(client, row)
        end
      end
    end

    def row_valid?(row)
      if row.size != HEADERS.size || !row[0].start_with?('PR0')
        return raise CSV::MalformedCSVError, 'Ivalid row'
      end

      true
    end

    def create_address(client, row)
      Address.create(
        client_id: client.id, address: row[3]
      ) unless row[3].gsub(',', '').empty?
    end

    def create_phones(client, row)
      Phone.create(
        client_id: client.id, phone: row[4]
      ) unless row[4].gsub('(null)', '').empty?
    end

    def create_calls(client, row)
      (5..7).each do |x|
        Call.create(
          client_id: client.id, call: row[x]
        ) unless row[x].gsub('(null)', '').empty?
      end
    end
  end
end
