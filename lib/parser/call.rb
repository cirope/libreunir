module Parser
  class Call < Base

    def initialize(row, client)
      @row, @client = row, client
    end

    def parse
      create_call
    end

    def create_call
      (5..7).each do |x|
        ::Call.create(
          client_id: @client.id, call: @row[x]
        ) if @row[x].to_s.gsub('(null)', '').present?
      end 
    end
  end
end
