module Parser
  class Payment < Base

    def line_save(row)
      if row_valid?(row)
        product_id = row[0].gsub('PR0', '').to_i

        user = ::User.find_by_username(row[21])
        product = ::Product.find_by_product_id(product_id)
        payment = ::Payment.find_by_product_id_and_number(product.try(:id), row[1])

        attributes = {
          number: row[1], expiration: row[2], payment_date: row[16],
          amount_paid: row[17], total: row[41], user_id: user.try(:id)
        }

        if payment.try(:persisted?)
          payment.update_attributes(attributes)
        else
          attributes.merge!(product_id: product.id)

          ::Payment.create(attributes)
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
