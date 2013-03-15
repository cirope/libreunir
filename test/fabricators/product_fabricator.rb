Fabricator(:product) do
  product_id { Faker::Lorem.sentence }
  branch_id { 100 * rand }
  delay_date { rand(1.year).ago }
  expired_debt { 100.0 * rand }
  total_debt { 100.0 * rand }
  expired_fees { 100 * rand }
  fees_to_expire { 100 * rand }
end
