module Parser
  class Order < Base
    def process_row(row)
      loan = ::Loan.find_by(loan_id: row[0].to_i)
      user = ::User.find_by(username: row[2])
      branch = ::Branch.find_by(branch_id: row[7].to_i)

      attributes = {
        loan_id: row[0].to_i,
        user_id: user.try(:id), 
        branch_id: branch.try(:id), 
        created_at: row[8]
      }

      loan = save_instance(loan, ::Loan, attributes)
      
      Parser::Tag.parse(row[48], loan)
    end

    def row_valid?(row)
      return raise CSV::MalformedCSVError, 'Invalid row' unless row[0] =~ /\A\d+\z/
      
      true
    end
  end
end
