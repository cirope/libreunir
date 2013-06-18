module Parser
  class Base
    COL_SEP = '|'
    FIRST_ROW = 4
    ENCODING = 'utf-16:utf-8'

    def initialize(path = nil)
      @tmp_row    = []

      if path
        @file       = File.open(@path, encoding: ENCODING)
        @row_length = initialize_row_length
      end
    end

    def initialize_row_length
      @file.each do |row|
        return row.split(' ').length if @file.lineno == 3
      end
    end

    def parse
      @file.each do |line|
        if @file.lineno > FIRST_ROW
          begin
            row = parse_line(line)

            if row_valid?(row)
              process_row(row)
            else
              fix_row(row)

              if row_valid?(@tmp_row)
                process_row(@tmp_row)

                @tmp_row.clear
              end
            end
          rescue
            Parser::Logger.log row
          end
        end
      end

      @file.close
    end

    def save_instance(instance, klass, attributes)
      if instance.try(:persisted?)
        instance.without_versioning do
          instance.update_attributes(attributes)
          instance.touch
        end
      else
        instance = klass.create(attributes)
      end 

      instance
    end

    private

    def fix_row(row)
      if @tmp_row.empty?
        @tmp_row = row
      else
        @tmp_row[-1] += "\r\n#{row.shift}"
        @tmp_row.concat(row)
      end
    end

    def parse_line(line)
      line.split(COL_SEP).map { |r| r.to_s.strip }
    end

    def row_valid?(row)
      @row_length == row.length
    end
  end
end
