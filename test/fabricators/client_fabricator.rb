Fabricator(:client) do
  name { Faker::Name.first_name }
  lastname { Faker::Name.last_name }
  identification { sequence(:client_identification) }
  address { Faker::Address.street_address }
  phone { Faker::PhoneNumber.phone_number }
end
