Fabricator(:loan) do
  loan_id { 100 * rand }
  approved_at { rand(1.year).ago }
  capital { 100.0 * rand }
  payment { 100.0 * rand }
  client { references }
  user { references }
  branch { references }
end
