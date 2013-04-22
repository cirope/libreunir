Fabricator(:loan) do
  loan_id { sequence(:loan_id) }
  approved_at { 1.day.ago.to_date }
  capital 1000.0
  payment 100.0
  client_id { Fabricate(:client).id }
  user_id { Fabricate(:user).id }
  branch_id { Fabricate(:branch).id }
end
