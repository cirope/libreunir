require_relative '../parser/processor'
require_relative '../parser/logger'
require_relative '../parser/base'

namespace :parser do
  desc 'Parse CSV files from SFTP'
  task run: ['importer:work', :process, :cleanup]

  files = [
    { model: :branch,  name: 'sucursal.txt',  cleanup: false },
    { model: :zone,    name: 'zona.txt',      cleanup: false },
    { model: :user,    name: 'usuario.txt',   cleanup: false },
    { model: :order,   name: 'solicitud.txt', cleanup: true  },
    { model: :loan,    name: 'prestamo.txt',  cleanup: true  },
    { model: :client,  name: 'clientes.txt',  cleanup: true  },
    { model: :payment, name: 'cuota.txt',     cleanup: true  },
    { model: :product, name: 'producto.txt',  cleanup: true  }
  ]

  @processor = Parser::Processor.new

  task process: :environment do
    files.each do |file|
      path = Dir.glob(
        File.expand_path('private/data') + '/' + file[:name], File::FNM_CASEFOLD
      ).first

      Parser::Logger.log "[ Parsing #{file[:name]} .... ========================================= ]"

      "Parser::#{file[:model].to_s.capitalize}".constantize.new(path).parse

      @processor.move_processed(path)
    end
  end

  task cleanup: :environment do
    files.each do |file|
      if file[:cleanup]
        klass = file[:model].to_s.capitalize.constantize rescue ::Loan

        Parser::Logger.log "Cleaning #{klass}..."
        @processor.cleanup(klass)
      end
    end
  end
end
