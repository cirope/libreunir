module Parser
  class Product < Base

    def line_save(row)
      if row_valid?(row)
        product_id = row[0].gsub('PR0', '')

        product = ::Product.find_by_product_id(product_id)
        branch = ::Branch.find_by_branch_id(row[2])

        attributes = {
          delay_date: row[3], expired_debt: row[7], total_debt: row[8], 
          debt_to_expire: row[96], delay_maximum: row[98], branch_id: branch.id
        }

        if product.try(:persisted?)
          product.update_attributes(attributes)
        else
          ::Product.create(attributes)
        end
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

    def self.parse_product(product_id, client)
      product = ::Product.find_by_product_id(product_id)
      
      if product.try(:persisted?)
        product.update_attributes(client_id: client.id)
      else
        ::Product.create(product_id: product_id, client_id: client.id)
      end
    end
  end
end
