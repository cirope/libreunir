Fabricator(:client) do
  name { Faker::Name.name }
  lastname { Faker::Name.name }
  segment { Faker::Lorem.sentence }
  identification { Faker::Lorem.sentence }
end
