Fabricator(:call) do
  client_id { Fabricate(:client).id }
  call { Faker::Lorem.paragraph }
end
