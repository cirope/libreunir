module Parser
  class Base
    def initialize(path = nil, encoding = nil, col_sep = nil, headers = nil)
      @path       = path
      @tmp_row    = []
      @col_sep    = col_sep  || '|'
      @headers    = headers  || 3
      @encoding   = encoding || 'utf-16:utf-8'
      @row_length = initialize_row_length if path
    end

    def initialize_row_length
      File.foreach(@path, encoding: @encoding) do |row|
        return row.split(' - ').length if row.start_with?('---')
      end
    end

    def parse
      index = 0

      File.foreach(@path, encoding: @encoding) do |line|
        if index > @headers
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
        index += 1
      end
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
        @tmp_row[-1] += " #{row.shift}"
        @tmp_row.concat(row)
      end
    end

    def parse_line(line)
      line.split(@col_sep).map { |r| r.to_s.strip }
    end

    def row_valid?(row)
      @row_length <= row.length
    end
  end
end
