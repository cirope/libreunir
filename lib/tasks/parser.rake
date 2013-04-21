require_relative '../parser/base'

task parser: :environment do

  files = {
    branch: 'sucursal.txt',
    user: 'usuario.txt',
    client: 'clientes.txt',
    product: 'producto.txt',
    payment: 'cuota.txt'
  }

  files.each do |klass,file|
    
    path = Dir.glob(
      File.expand_path("private/data") + '/' + files[klass], File::FNM_CASEFOLD
    ).first

    puts "[ Parsing #{file} .... ========================================= ]"

    parser = "Parser::#{klass.to_s.capitalize}".constantize.new(path)
    parser.parse
  end
end
