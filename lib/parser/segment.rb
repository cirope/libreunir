module Parser
  class Segment < Base

    def line_save(row)
      ::Segment.where(segment_id: row[0]).first_or_create(
        segment_id: row[0], description: row[1], status: row[16].to_i 
      ) if row_valid?(row)
    end

    def row_valid?(row)
      ['Job', 'SegmentoID', '---', '0'].each do |str|
        if row[0].nil? || row[0].start_with?(str)
          return raise CSV::MalformedCSVError, 'Invalid row'
        end
      end
      
      true
    end
  end
end
