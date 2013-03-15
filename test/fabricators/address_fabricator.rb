Fabricator(:address) do
  client_id { references }
  street { Faker::Lorem.sentence }
  number { 100 * rand }
  floor { 100 * rand }
  location { Faker::Lorem.sentence }
  postal_code { 100 * rand }
end
