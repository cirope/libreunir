Fabricator(:fee) do
  loan { references }
  amount { 100.0 * rand }
  expiration_date { rand(1.year).ago }
  payment_date { rand(1.year).ago }
  note { Faker::Lorem.paragraph }
end
