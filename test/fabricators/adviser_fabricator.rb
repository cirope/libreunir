Fabricator(:adviser) do
  name { Faker::Name.name }
  lastname { Faker::Name.name }
  identification { Faker::Lorem.sentence }
  branch { references }
end
