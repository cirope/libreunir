module Parser
  class NotRenewed < Base
    def process_row(row)
      loan_id = row[1].gsub('PR0', '').to_i
      loan = ::Loan.find_by(loan_id: loan_id)
      client = client_first_or_create(row)

      attributes = { 
        loan_id: loan_id,
        payments_count: row[6],
        payment: row[7],
        capital: row[8],
        canceled_at: row[14],
        user_id: ::User.find_by(name: row[11]).try(:id),
        branch_id: ::Branch.find_by(name: row[12]).try(:id),
        client_id: client.id
      }

      save_instance(loan, ::Loan, attributes)
    end

    def client_first_or_create(row)
      client = Parser::Client.new.first_or_create(
        identification: row[2], name: row[3], address: row[4]
      )

      ::Phone.create(phone: row[5], client_id: client.id) if client

      client
    end
  end
end
