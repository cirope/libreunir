Fabricator(:loan) do
  order_id {  Fabricate(:client).id }
  amount { 100.0 * rand }
  grant_date { rand(1.year).ago }
  expiration_date { rand(1.year).ago }
  amount_to_finance { 100 * rand }
  capital { 100 * rand }
  number_of_fees { 100 * rand }
end
