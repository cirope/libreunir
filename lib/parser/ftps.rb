require 'fileutils'

module Parser
  class Ftps
    def initialize
      user = APP_CONFIG['ftps']['user']
      password = APP_CONFIG['ftps']['password']
      address = APP_CONFIG['ftps']['address']

      @file = APP_CONFIG['zip']['filename']
      @path = File.expand_path('private') + '/' + @file
      @url = "ftp://#{user}:#{password}@#{address}"
    end

    def make_folder
      FileUtils.mkdir_p(File.expand_path('private'))
    end

    def get_file
      %x{curl #@url/#@file -s -k --ftp-ssl -o #@path}
    end

    def put_file file
      %x{curl #@url -s -k --ftp-ssl -T #{file}}
    end
  end
end
