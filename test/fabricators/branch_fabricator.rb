Fabricator(:branch) do
  branch_id { sequence(:branch_id) }
  name { Faker::Name.name }
  address { Faker::Address.street_address }
end
