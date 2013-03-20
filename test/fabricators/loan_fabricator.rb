Fabricator(:loan) do
  client_id {  Fabricate(:client).id }
  adviser_id {  Fabricate(:adviser).id }
  amount { 100.0 * rand }
  grant_date { rand(1.year).ago }
  expiration_date { rand(1.year).ago }
  product_id {  Fabricate(:client).id }
  amount_to_finance { 100 * rand }
  capital { 100 * rand }
  number_of_fees { 100 * rand }
end
