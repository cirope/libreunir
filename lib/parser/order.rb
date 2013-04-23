module Parser
  class Order < Base

    def line_save(row)
      if row_valid?(row)

        loan = ::Loan.find_by_loan_id(row[0])
        user = ::User.find_by_username(row[2])
        branch = ::Branch.find_by_branch_id(row[7])

        attributes = {
          approved_at: row[10], user_id: user.try(:id), 
          branch_id: branch.try(:id), created_at: row[8]
        }

        if loan.try(:persisted?)
          loan.update_attributes(attributes)
          loan.touch
        else
          attributes.merge!(loan_id: row[0])

          ::Loan.create(attributes)
        end
      end
    end

    def row_valid?(row)
      return raise CSV::MalformedCSVError, 'Invalid row' unless row[0] =~ /\A\d+\z/
      
      true
    end
  end
end
