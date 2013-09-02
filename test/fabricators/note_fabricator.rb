Fabricator(:note) do
  note { Faker::Lorem.paragraph }
  user_id { Fabricate(:user).id }
  noteable_id { Fabricate(:schedule).id }
  noteable_type 'Schedule'
end
