module Parser
  class Branch < Base
    def process_row(row)
      branch = ::Branch.find_by(branch_id: row[0].to_i)
      attributes = { branch_id: row[0].to_i, name: row[3], address: row[17] }

      save_instance(branch, ::Branch, attributes) 
    end
  end
end
