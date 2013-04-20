Fabricator(:loan) do
  order_id { Fabricate(:order).id }
  amount { 100.0 * rand }
  grant_date { rand(1.year).ago }
  expiration_date { Date.tomorrow }
  amount_to_finance { 100 * rand }
  capital { 100 * rand }
  number_of_fees { 100 * rand }
end

Fabricator(:loan_for_user, from: :loan) do
  transient :user_id
  order_id { |attrs| Fabricate(:order, adviser_id: attrs[:user_id]).id } 
end
