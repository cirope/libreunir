Fabricator(:fee) do
  loan_id {  Fabricate(:loan).id }
  amount { 100.0 * rand }
  expiration_date { rand(1.year).ago }
  payment_date { nil }
  fee_number { 100 * rand }
  total_amount { 100 * rand }
end
