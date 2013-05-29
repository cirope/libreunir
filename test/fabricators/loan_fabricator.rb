Fabricator(:loan) do
  loan_id { sequence(:loan_id) }
  delayed_at nil
  capital 1000.0
  payment 100.0
  expired_payments_count 0
  payments_to_expire_count 12
  next_payment_expire_at { 10.days.from_now.to_date }
  client_id { Fabricate(:client).id }
  user_id { Fabricate(:user).id }
  branch_id { Fabricate(:branch).id }
end
