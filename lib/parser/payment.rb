module Parser
  class Payment < Base

    def line_save(row)
      if row_valid?(row)
        loan_id = row[0].gsub('PR0', '').to_i

        attributes = {
          amount: row[17].to_f, expiration_date: row[2], payment_date: row[16],
          fee_number: row[1].to_i, total_amount: row[41].to_i,
          loan_id: loan_id.to_i, paid_to: row[21].to_s.gsub('(null)', '')
        }

        ::Payment.create(attributes)
      end
    end

    def row_valid?(row)
      if !row[0].start_with?('PR0')
        return raise CSV::MalformedCSVError, 'Invalid row'
      end
      
      true
    end
  end
end
