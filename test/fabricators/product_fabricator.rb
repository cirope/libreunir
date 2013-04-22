Fabricator(:product) do
  product_id { sequence(:product_id) }
  delay_date { 1.day.from_now.to_date }
  expired_debt 0.0
  total_debt 100.0
  debt_to_expire 100.0
  delay_maximum 0
  client_id { Fabricate(:client).id }
  branch_id { Fabricate(:branch).id }
end
