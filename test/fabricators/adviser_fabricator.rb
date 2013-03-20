Fabricator(:adviser) do
  name { Faker::Name.name }
  lastname { Faker::Name.name }
  identification { 100 * rand }
  branch_id { Fabricate(:branch).id }
end
