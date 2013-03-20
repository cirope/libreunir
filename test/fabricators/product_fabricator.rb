Fabricator(:product) do
  product_id { 100 * rand }
  branch_id { Fabricate(:branch).id }
  delay_date { rand(1.year).ago }
  expired_debt { 100.0 * rand }
  total_debt { 100.0 * rand }
  expired_fees { 100 * rand }
  fees_to_expire { 100 * rand }
end
