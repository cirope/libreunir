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
        progress: 100,
        canceled_at: row[25],
        user_id: ::User.where('name ILIKE ?', "%#{row[22]}%").first.try(:id),
        branch_id: ::Branch.where('name ILIKE ?', "%#{row[23]}%").first.try(:id),
        client_id: client.id
      }

      save_instance(loan, ::Loan, attributes)
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
