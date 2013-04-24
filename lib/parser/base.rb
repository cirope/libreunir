module Parser
  class Base
    require 'csv'
    require 'logger'

    def initialize(path = nil, encoding = nil)
      @path     = path
      @encoding = encoding || 'utf-16:utf-8'
      @logger = Logger.new("#{@path}_#{Time.new.strftime('%d_%m_%Y')}.log")
    end

    def parse
      File.foreach(@path, encoding: @encoding) do |line|
        begin
          CSV.parse(line, col_sep: '|', skip_blanks: true, quote_char: "\n", headers: false) do |row| 
            row.map! { |r| r.to_s.strip }

            process_row(row) if row_valid?(row)
          end
        rescue CSV::MalformedCSVError => e
          puts e.message

          @logger.error line
        end
      end
    end

    def save_instance(instance, field_id, klass, attributes)
      if instance.try(:persisted?)
        instance.update_attributes(attributes)
        instance.touch
      else
        attributes.merge!(field_id)
        klass.create(attributes)
      end 
    end
  end
end
