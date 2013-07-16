module Parser
  class Zone < Base
    def process_row(row)
      branch = ::Branch.find_by(branch_id: row[2].to_i)
      zone = ::Zone.find_by(zone_id: row[0])
      attributes = { name: row[1].titleize, zone_id: row[0], branch_id: branch.try(:id) }

      save_instance(zone, ::Zone, attributes) 
    end
  end
end
