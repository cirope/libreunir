Fabricator(:phone) do
  phone { Faker::PhoneNumber.phone_number }
  client_id { Fabricate(:client).id }
end
