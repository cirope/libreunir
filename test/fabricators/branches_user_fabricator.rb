Fabricator(:branches_user) do
  branch_id { Fabricate(:branch).id }
  user_id { Fabricate(:user).id }
end
