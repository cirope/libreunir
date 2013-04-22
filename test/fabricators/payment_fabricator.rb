Fabricator(:payment) do
  product_id { Fabricate(:product).id }
  number { |attrs| sequence(:"payment_number_{attrs[:product_id]}", 1) }
  expiration { 2.days.from_now.to_date }
  payment_date { 1.day.ago.to_date }
  total 100.0
  amount_paid { |attrs| attrs[:total] }
  user_id { Fabricate(:user).id }
end
