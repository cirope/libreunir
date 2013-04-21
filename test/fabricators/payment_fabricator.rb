Fabricator(:payment) do
  number { 100 * rand }
  expiration { rand(1.year).ago }
  payment_date { rand(1.year).ago }
  amount_paid { 100.0 * rand }
  total { 100.0 * rand }
  product { references }
  user { references }
end
