module Parser
  class Payment < Base

    def line_save(row)
      if row_valid?(row)
        product_id = row[0].gsub('PR0', '').to_i

        user = ::User.find_by_username(row[21])
        product = ::Product.find_by_product_id(product_id)

        if product.try(:persisted?)

          attributes = {
            number: row[1], expiration: row[2], payment_date: row[16],
            amount_paid: row[17], total: row[41], product_id: product.id
          }

          attributes.merge!(user_id: user.id) if user.try(:persisted?)

          ::Payment.create(attributes)
        else
          return raise CSV::MalformedCSVError, 'Product not persisted'
        end
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
