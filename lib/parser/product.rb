module Parser
  class Product < Base

    def line_save(row)
      if row_valid?(row)
        product_id = row[0].gsub('PR0', '').to_i.to_s
        product = ::Product.where(product_id: product_id).first

        attributes = {
          product_id: product_id, branch_id: row[2], delay_date: row[3],
          expired_debt: row[7].to_f, total_debt: row[8].to_f, expired_fees: row[95].to_i,
          fees_to_expire: row[96].to_i
        }

        if product && product.persisted?
          product.update_attributes(attributes)
        else
          ::Product.create(attributes)
        end
      end
    end

    def row_valid?(row)
      ['Job', 'ProductoID', '---'].each do |str|
        if row[0].nil? || row[0].start_with?(str)
          return raise CSV::MalformedCSVError, 'Invalid row'
        end
      end
      
      true
    end
  end
end
