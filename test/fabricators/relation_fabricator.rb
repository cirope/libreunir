Fabricator(:relation) do
  relation { Relation::TYPE.sample }
  user_id { Fabricate(:user).id }
  relative_id { Fabricate(:user).id }
end
