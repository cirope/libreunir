module Parser
  class Order < Base
    def process_row(row)
      loan = ::Loan.find_by(loan_id: row[0].to_i)
      segment = ::Segment.find_by(segment_id: row[2])
      branch = ::Branch.find_by(branch_id: row[3].to_i)
      user = ::User.find_by(username: row[5])
      zone = ::Zone.find_by(zone_id: row[1])

      attributes = {
        loan_id: row[0].to_i,
        segment_id: segment.try(:id),
        branch_id: branch.try(:id),
        user_id: user.try(:id), 
        zone_id: zone.try(:id),
        created_at: row[4]
      }

      save_instance(loan, ::Loan, attributes)
    end
  end
end
