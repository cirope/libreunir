Fabricator(:comment) do
  comment { Faker::Lorem.paragraph }
  loan_id { Fabricate(:loan).id }
  user_id { Fabricate(:user).id }
end
