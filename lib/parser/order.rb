module Parser
  class Order < Base

    def line_save(row)
      if row_valid?(row)
        order_id = row[0].to_i

        attributes = {
          order_id: order_id, adviser_id: row[2], segment_id: row[4],
          branch_id: row[7].to_i, zone_id: row[48].to_i, 
          assigned_adviser_id: row[67].to_s.gsub('(null)', ''), user_id: row[46]
        }

        ::Order.create(attributes)
      end
    end

    def row_valid?(row)
      ['Job', 'SolicitudID', '---'].each do |str|
        if row[0].start_with?(str)
          return raise CSV::MalformedCSVError, 'Invalid row'
        end
      end
      
      true
    end
  end
end
