Fabricator(:client) do
  name { Faker::Name.name }
  product_id {  100*rand }
  identification { 100*rand }
end
