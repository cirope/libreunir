Fabricator(:note) do
  note { Faker::Lorem.paragraph }
  noteable_id { Fabricate(:schedule).id }
  noteable_type 'Schedule'
end
