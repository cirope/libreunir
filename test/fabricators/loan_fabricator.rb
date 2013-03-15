Fabricator(:loan) do
  client { references }
  adviser { references }
  amount { 100.0 * rand }
  grant_date { rand(1.year).ago }
  expiration_date { rand(1.year).ago }
end
