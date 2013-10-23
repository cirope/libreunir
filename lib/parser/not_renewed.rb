module Parser
  class NotRenewed < Base
    def process_row(row)
      loan_id = row[1].gsub('PR0', '').to_i
      loan = ::Loan.find_by(loan_id: loan_id)
      client = client_first_or_create(row)

      attributes = { 
        loan_id: loan_id,
        payments_count: row[17],
        payment: row[18],
        capital: row[19],
        days_overdue_average: row[21].to_f.round,
        canceled_at: row[25],
        user_id: ::User.find_by(username: row[26]).try(:id),
        segment_id: ::Segment.find_by(segment_id: row[27]).try(:id),
        branch_id: ::Branch.find_by(branch_id: row[28].to_i).try(:id),
        client_id: client.id
      }.merge(default_attributes)

      loan = save_instance(loan, ::Loan, attributes)

      loan.payments.where(paid_at: nil).each { |p| p.update(paid_at: (loan.canceled_at || Time.now)) }
    end

    def default_attributes
      {
        debtor: false,
        progress: 100,
        delayed_at: nil,
        state: 'not_renewed',
        expired_payments_count: 0,
        payments_to_expire_count: 0,
        next_payment_expire_at: nil
      }
    end

    def client_first_or_create(row)
      client = Parser::Client.new.first_or_create(
        identification: row[2], name: row[3], address: row[4]
      )
      client_phones(row, client)

      client
    end

    def client_phones(row, client)
      if client
        attributes = {
          tel1: row[5], tel2: row[6], tel3: row[7], tel4: row[8],
          cel1_code: row[9], cel1: row[10], cel1_com: row[11], cel1_radio: row[12],
          cel2_code: row[13], cel2: row[14], cel2_com: row[15], cel2_radio: row[16]
        }

        Parser::Phone.new(attributes, client).parse
      end
    end
  end
end
