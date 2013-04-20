Fabricator(:fee) do
  loan_id { Fabricate(:loan).id }
  amount 100.0
  expiration_date { Date.tomorrow }
  payment_date nil
  fee_number { sequence(:fee_number, 1) }
  total_amount 100
end

Fabricator(:fee_for_user, from: :fee) do
  transient :user_id
  loan_id { |attrs| Fabricate(:loan_for_user, user_id: attrs[:user_id]).id }
end
