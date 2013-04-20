module Parser
  class Address < Base

    def initialize(row, client)
      @row, @client = row, client
    end

    def parse
      create_address
    end

    def create_address
      ::Address.create(
        client_id: @client.id, address: @row[3]
      ) unless @row[3].gsub(',', '').empty?
    end

  end
end
