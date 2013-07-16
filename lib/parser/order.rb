module Parser
  class Order < Base
    def process_row(row)
      loan = ::Loan.find_by(loan_id: row[0].to_i)
      user = ::User.find_by(username: row[45])
      branch = ::Branch.find_by(branch_id: row[7].to_i)
      zone = ::Zone.find_by(zone_id: row[48])

      attributes = {
        loan_id: row[0].to_i,
        user_id: user.try(:id), 
        branch_id: branch.try(:id), 
        zone_id: zone.try(:id),
        created_at: row[8]
      }

      save_instance(loan, ::Loan, attributes)
    end
  end
end
