Fabricator(:address) do
  client_id { Fabricate(:client).id }
  street { Faker::Lorem.sentence }
  number { 100 * rand }
  floor { 100 * rand }
  location { Faker::Lorem.sentence }
  postal_code { 100 * rand }
  address { Faker::Address.street_address }
end
