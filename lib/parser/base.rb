require 'csv'

module Parser
  class Base
    def initialize(path = nil, encoding = nil)
      @path     = path
      @encoding = encoding || 'utf-16:utf-8'
    end

    def parse
      File.foreach(@path, encoding: @encoding) do |line|
        begin
          CSV.parse(line, col_sep: '|', skip_blanks: true, quote_char: "\n", headers: false) do |row| 
            row.map! { |r| r.to_s.strip }

            process_row(row) if row_valid?(row)
          end
        rescue CSV::MalformedCSVError => e
          Parser::Logger.log e.message
        end
      end
    end

    def save_instance(instance, field_id, klass, attributes)
      if instance.try(:persisted?)
        instance.without_versioning do
          instance.update_attributes(attributes)
          instance.touch
        end
      else
        attributes.merge!(field_id)
        instance = klass.create(attributes)
      end 

      instance
    end
  end
end
