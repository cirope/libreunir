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
      phones = extract_phones

      phones.delete_if { |p| p[:phone].blank? }
      phones.each { |p| create_phone(p) unless @phones.include?(p[:phone]) }

      (@phones - phones.map { |p| p[:phone] }).each { |p| destroy_phone(p) }
    end

    private

    def extract_phones
      phones = []

      [4, 8, 9, 10, 11].each { |idx| phones << { phone: @row[idx] } }

      phones << extract_phone([12, 13], 14)
      phones << extract_phone([15], 14)
      phones << extract_phone([16, 17], 18)
      phones << extract_phone([19], 18)

      phones
    end

    def extract_phone(phone_cols, carrier_col)
      {
        phone: phone_cols.map { |col| @row[col] }.reject(&:blank?).join(' '),
        carrier: CARRIER[@row[carrier_col]]
      }
    end

    def create_phone(attributes)
      @client.phones.create(attributes)
    end

    def destroy_phone(phone)
      @client.phones.find_by(phone: phone).try(:destroy)
    end
  end
end
