Fabricator(:user) do
  name { Faker::Name.first_name }
  username { |attrs| [attrs[:name], sequence(:user_id)].join('_').downcase }
  email { |attrs| Faker::Internet.email(attrs[:username]) }
  password { Faker::Lorem.sentence }
  password_confirmation { |attrs| attrs[:password] }
  file_number { sequence(:user_file_number) }
  identification { sequence(:user_identification) }
  date_entry { 1.year.ago.to_date }
  branch_id { Fabricate(:branch).id }
  role :admin
end
