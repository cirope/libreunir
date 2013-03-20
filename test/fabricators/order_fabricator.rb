Fabricator(:order) do
  order_id {  100 * rand }
  adviser_id { Fabricate(:adviser).id }
  segment_id { Fabricate(:segment).id }
  branch_id { Fabricate(:branch).id }
  zone_id { Fabricate(:zone).id }
  assigned_adviser_id { Fabricate(:adviser).id }
end
