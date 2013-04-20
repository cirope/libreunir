module Parser
  class Phone < Base

    def initialize(row, client)
      @row, @client = row, client
    end

    def parse
      create_phone
    end

    def create_phone
      ::Phone.create(
        client_id: @client.id, phone: @row[4]
      ) unless @row[4].to_s.gsub('(null)', '').empty?
    end
  end
end
