require_relative '../parser/processor'
require_relative '../parser/logger'
require_relative '../parser/base'

namespace :parser do
  desc 'Parse CSV files from SFTP'
  #task run: ['importer:work', :process, :cleanup]
  task run: [:process]

  files = [
    #{ model: :segment,  name: 'segmento.txt'  },
    #{ model: :branch,   name: 'sucursal.txt'  },
    #{ model: :zone,     name: 'zona.txt'      },
    #{ model: :user,     name: 'usuario.txt'   },
    #{ model: :order,    name: 'solicitud.txt' },
    #{ model: :loan,     name: 'prestamo.txt'  },
    #{ model: :client,   name: 'clientes.txt'  },
    { model: :payment,  name: 'cuota.txt'     },
    #{ model: :product,  name: 'producto.txt'  },
    #{ model: :not_renewed, name: 'clientessinrenovar.txt' }
  ]

  @processor = Parser::Processor.new

  task process: :environment do
    files.each do |file|
      path = Dir.glob(
        File.expand_path('private/data') + '/' + file[:name], File::FNM_CASEFOLD
      ).first

      Parser::Logger.log "[ Parsing #{file[:name]} .... ========================================= ]"

      "Parser::#{file[:model].to_s.camelize}".constantize.new(path).parse

      @processor.move_processed(path)
    end
  end

  task cleanup: :environment do
    Parser::Logger.log "Cleaning loans..."
    @processor.cleanup
  end
end
