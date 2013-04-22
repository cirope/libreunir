module Parser
  class Branch < Base

    def line_save(row)
      if row_valid?(row)
        branch_id = row[0].to_i

        branch = ::Branch.find_by_branch_id(branch_id)
        attributes = { name: row[3], address: row[17] }

        if branch.try(:persisted?)
          branch.update_attributes(attributes)
        else
          attributes.merge!(branch_id: branch_id)

          ::Branch.create(attributes)
        end
      end
    end

    def row_valid?(row)
      ['Job', 'SucursalID', '---'].each do |str|
        if row[0].start_with?(str)
          return raise CSV::MalformedCSVError, 'Invalid row'
        end
      end

      true
    end
  end
end
