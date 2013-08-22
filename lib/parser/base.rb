module Parser
  class Base
    FIRST_ROW = 4
    COL_SEP_SIZE = 3
    ENCODING = 'utf-16:utf-8'

    def initialize(path = nil)
      if path
        @file      = File.open(path, encoding: ENCODING)
        @tmp_line  = ''
        @columns   = []
        @header    = 0

        initialize_attrs
      end
    end

    def initialize_attrs
      @file.each do |row|
        if @file.lineno == 4
          @header = row.length
          row.split(' ').reject { |c| c == '-' }.map { |c| @columns << c.length }

          return
        end
      end
    end

    def parse
      @file.each do |line|
        if @file.lineno > FIRST_ROW
          begin
            if line_valid?(line)
              process_row(parse_line(line))
            else
              @tmp_line << line

              if line_valid?(@tmp_line)
                process_row(parse_line(@tmp_line))

                @tmp_line = ''
              end
            end
          rescue Exception => e
            Parser::Logger.log "#{e.message} == #{line}"
          end
        end
      end

      @file.close
    end

    def save_instance(instance, klass, attributes)
      if instance.try(:persisted?)
        instance.without_versioning do
          instance.update_attributes(attributes)
        end
      else
        instance = klass.create(attributes)
      end 

      instance
    end

    private

    def parse_line(line)
      tmp_c = 0
      tmp_row = []

      @columns.each do |c|
        tmp_row << line[tmp_c, c]
        tmp_c += (c + COL_SEP_SIZE)
      end

      tmp_row.map { |r| r.to_s.strip.gsub('(null)', '') }
    end

    def line_valid?(line)
      line.length >= (@header - @columns[-1])
    end
  end
end
