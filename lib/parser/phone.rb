module Parser
  class Phone
    CARRIER = {
      'CLAR' => 'Claro',
      'MOVI' => 'Movistar',
      'NEXT' => 'Nextel',
      'PERS' => 'Personal'
    }

    def initialize(row, client)
      @row = row
      @client = client
      @phones = client.phones.pluck('phone')
    end

    def parse
      new_phones = []

      [4, 8, 9, 10, 11].each { |idx| new_phones << { phone: @row[idx] } }
      new_phones << { phone: [@row[12], @row[13]].reject(&:blank?).join(' '), carrier: CARRIER[@row[14]] }
      new_phones << { phone: @row[15], carrier: CARRIER[@row[14]] }
      new_phones << { phone: [@row[16], @row[17]].reject(&:blank?).join(' '), carrier: CARRIER[@row[18]] }
      new_phones << { phone: @row[19], carrier: CARRIER[@row[18]] }

      new_phones.delete_if { |p| p[:phone].blank? }
      new_phones.each { |p| create_phone(p) unless @phones.include?(p[:phone]) }
      (@phones - new_phones.map { |p| p[:phone] }).each { |p| destroy_phone(p) }
    end

    private

    def create_phone(attributes)
      @client.phones.create(attributes)
    end

    def destroy_phone(phone)
      @client.phones.find_by(phone: phone).try(:destroy)
    end
  end
end
