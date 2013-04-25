require 'double_bag_ftps'
require 'fileutils'

module Parser
  class Ftps
    def initialize
      @ftps = DoubleBagFTPS.new
    end

    def make_folder
      FileUtils.mkdir_p(File.expand_path("private"))
    end

    def set_mode
      @ftps.ftps_mode = DoubleBagFTPS::EXPLICIT
    end

    def set_context
      @ftps.ssl_context = DoubleBagFTPS.create_ssl_context(verify_mode: OpenSSL::SSL::VERIFY_NONE)
    end

    def connect_and_login
      @ftps.connect(APP_CONFIG['ftps']['address'], APP_CONFIG['ftps']['port'])
      @ftps.login(APP_CONFIG['ftps']['user'], APP_CONFIG['ftps']['password'])
    end

    def get_file
      @ftps.passive = true
      @ftps.chdir(APP_CONFIG['zip']['path'])
      @ftps.get(APP_CONFIG['zip']['filename'], File.expand_path("private") + '/' + APP_CONFIG['zip']['filename'])
    ensure
      @ftps.close
    end
  end
end