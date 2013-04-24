module Parser
  class Branch < Base
    def process_row(row)
      branch = ::Branch.find_by(branch_id: row[0].to_i)
      attributes = { name: row[3], address: row[17] }

      save_instance(branch, { branch_id: row[0] }, ::Branch, attributes) 
    end

    def row_valid?(row)
      return raise CSV::MalformedCSVError, 'Invalid row' unless row[0] =~ /\A\d+\z/
      
      true
    end
  end
end
