module Parser
  class Base
    require 'csv'
    require 'logger'

    def initialize(path, encoding = nil)
      @path     = path
      @encoding = encoding || 'utf-16:utf-8'
      @logger = Logger.new("#{@path}_#{Time.new.strftime('%d_%m_%Y')}.log")

      @headers = false # TODO: @headers = extract_headers
    end

    def parse
      File.foreach(@path, encoding: @encoding) do |line|
        begin
          CSV.parse(line, col_sep: '|', skip_blanks: true, quote_char: "\n", headers: @headers) do |row| 
            row.map! { |r| r.to_s.strip }

            line_save(row)
          end
        rescue CSV::MalformedCSVError => e
          puts e.message

          @logger.error line
        end
      end
    end

    def extract_headers
      line_headers = File.foreach(@path) { |line| break line if $. == 3 }

      line_headers.split().delete_if { |h| h.size <= 4 }
    end
  end
end
