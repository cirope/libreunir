Fabricator(:tagging) do
  tag_id { Fabricate(:tag).id }
  taggable_id { Fabricate(:loan).id }
  taggable_type 'Loan'
end
