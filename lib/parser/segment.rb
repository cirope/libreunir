module Parser
  class Segment < Base
    def process_row(row)
      if row[0] != '0'
        segment = ::Segment.find_by(segment_id: row[0])

        attributes = {
          segment_id: row[0],
          description: row[1],
          short_description: row[49]
        }

        save_instance(segment, ::Segment, attributes)
      end
    end
  end
end
