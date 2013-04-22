Fabricator(:payment) do
  loan_id { Fabricate(:loan).id }
  number { |attrs| sequence(:"payment_number_{attrs[:loan_id]}", 1) }
  expired_at { 2.days.from_now.to_date }
  paid_at { 1.day.ago.to_date }
  total_paid 100.0
  amount_paid { |attrs| attrs[:total] }
  user_id { Fabricate(:user).id }
end
