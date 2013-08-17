module Parser
  class Phone
    CARRIER = {
      'CLAR' => 'Claro',
      'MOVI' => 'Movistar',
      'NEXT' => 'Nextel',
      'PERS' => 'Personal'
    }

    def initialize(phones, client)
      @phones = phones
      @client = client
      @db_phones = client.phones.pluck('phone')
    end

    def parse
      phones = extract_phones

      phones.delete_if { |p| p[:phone].blank? || p[:phone].gsub('-', ' ').blank? }
      phones.each { |p| create_phone(p) unless @db_phones.include?(p[:phone]) }

      (@db_phones - phones.map { |p| p[:phone] }).each { |p| destroy_phone(p) }
    end

    private

    def extract_phones
      phones = []

      [:tel1, :tel2, :tel3, :tel4, :tel5].each { |key| phones << { phone: @phones[key] } }

      phones << extract_phone([:cel1_code, :cel1], :cel1_com)
      phones << extract_phone([:cel1_radio], :cel1_com)
      phones << extract_phone([:cel2_code, :cel2], :cel2_com)
      phones << extract_phone([:cel2_radio], :cel2_com)

      phones
    end

    def extract_phone(phone_cols, carrier_col)
      {
        phone: phone_cols.map { |col| @phones[col] }.reject(&:blank?).join(' '),
        carrier: CARRIER[@phones[carrier_col]]
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
