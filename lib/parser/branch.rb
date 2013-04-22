module Parser
  class Branch < Base

    def line_save(row)
      if row_valid?(row)

        branch = ::Branch.find_by_branch_id(row[0])
        attributes = { name: row[3], address: row[17] }

        if branch.try(:persisted?)
          branch.update_attributes(attributes)
        else
          attributes.merge!(branch_id: row[0])

          ::Branch.create(attributes)
        end
      end
    end

    def row_valid?(row)
      return raise CSV::MalformedCSVError, 'Invalid row' unless row[0] =~ /\A\d+\z/
      
      true
    end
  end
end
