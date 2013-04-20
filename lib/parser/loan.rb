module Parser
  class Loan < Base

    def line_save(row)
      if row_valid?(row)
        order_id = row[0].gsub('PR0', '').to_i

        attributes = {
          order_id: order_id, amount: row[4].to_f, grant_date: row[6],
          expiration_date: row[39], fund_id: row[1].to_i, 
          amount_to_finance: row[29].to_f, capital: row[2].to_f, 
          number_of_fees: row[3].to_i
        }

        ::Loan.create(attributes)
      end
    end

    def row_valid?(row)
      ['Job', 'ProductoID', '---'].each do |str|
        if row[0].start_with?(str)
          return raise CSV::MalformedCSVError, 'Invalid row'
        end
      end
      
      true
    end
  end
end
