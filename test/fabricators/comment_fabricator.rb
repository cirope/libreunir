Fabricator(:comment) do
  comment { Faker::Lorem.paragraph }
  client_id { Fabricate(:client).id }
  user_id { Fabricate(:user).id }
end
