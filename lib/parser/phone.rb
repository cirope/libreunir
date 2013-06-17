module Parser
  class Phone
    def initialize(row, client)
      @row = row
      @client = client
      @phones = client.phones.map(&:phone)
    end

    def parse
      new_phones = []

      [4, 8, 9, 10, 11].each { |idx| new_phones << @row[idx] }
      new_phones << [@row[12], @row[13]].compact.join(' ')
      [14, 15].each { |idx| new_phones << @row[idx] }
      new_phones << [@row[16], @row[17]].compact.join(' ')
      [18, 19].each { |idx| new_phones << @row[idx] }

      new_phones.delete_if { |p| p.to_s.gsub('(null)', '').blank? }

      if @phones.empty?
        new_phones.each { |p| create_phone(p) }
      else
        (@phones - new_phones).each { |p| destroy_phone(p) }
        (new_phones - @phones).each { |p| create_phone(p) }
      end
    end

    private

    def create_phone(phone)
      @client.phones.create(phone: phone)
    end

    def destroy_phone(phone)
      @client.phones.find_by(phone: phone).destroy
    end
  end
end
