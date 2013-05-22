Fabricator(:tagging) do
  tag_id { Fabricate(:tag).id }
  taggable_type 'Loan'
  taggable_id { Fabricate(:loan).id }
end
