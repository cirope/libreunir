module Parser
  class Base
    require 'csv'
    require 'logger'

    def initialize(path, encoding = nil)
      @path     = path
      @encoding = encoding || 'utf-16:utf-8'
      @logger = Logger.new("#{@path}_#{Time.new.strftime('%d_%m_%Y')}.log")
    end

    def parse
      File.foreach(@path, encoding: @encoding) do |line|
        begin
          CSV.parse(line, col_sep: '|', skip_blanks: true, quote_char: "\n", headers: false) do |row| 
            row.map! { |r| r.to_s.strip }

            line_save(row)
          end
        rescue CSV::MalformedCSVError => e
          puts e.message

          @logger.error line
        end
      end
    end
  end
end
