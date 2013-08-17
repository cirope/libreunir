Fabricator(:loan) do
  loan_id { sequence(:loan_id) }
  delayed_at nil
  capital 1000.0
  payment 100.0
  total_debt 200.0
  days_overdue_average 2 
  expired_payments_count 0
  payments_to_expire_count 12
  payments_count 24
  progress 50
  next_payment_expire_at { 10.days.from_now.to_date }
  canceled_at nil
  client_id { Fabricate(:client).id }
  user_id { Fabricate(:user).id }
  branch_id { Fabricate(:branch).id }
  zone_id { Fabricate(:zone).id }
end
