Fabricator(:phone) do
  client_id { references }
  number { Faker::Lorem.sentence }
end
