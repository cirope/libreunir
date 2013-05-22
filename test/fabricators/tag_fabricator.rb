Fabricator(:tag) do
  name { Faker::Name.name }
  category { Tag::CATEGORIES.sample }
  user_id { Fabricate(:user).id }
end
