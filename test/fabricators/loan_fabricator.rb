Fabricator(:loan) do
  loan_id { 100 * rand }
  approved { rand(1.year).ago }
  capital { 100.0 * rand }
  payment { 100.0 * rand }
  branch { preferences }
  user { preferences }
end
