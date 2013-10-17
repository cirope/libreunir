module Parser
  class Order < Base
    def process_row(row)
      loan = ::Loan.find_by(loan_id: row[0].to_i)

      attributes = {
        loan_id: row[0].to_i,
        segment_id: ::Segment.find_by(segment_id: row[2]).try(:id),
        branch_id: ::Branch.find_by(branch_id: row[3].to_i).try(:id),
        user_id: ::User.find_by(username: row[5]).try(:id),
        zone_id: ::Zone.find_by(zone_id: row[1]).try(:id),
        created_at: row[4],
        state: 'current'
      }
      loan.without_versioning { loan.touch } if loan.try(:persisted?)

      save_instance(loan, ::Loan, attributes)
    end
  end
end
