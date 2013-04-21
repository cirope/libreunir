require_relative '../parser/base'

task parser: :environment do

  files = {
    Branch: 'sucursal.txt',
    User: 'usuario.txt',
    Client: 'clientes.txt',
    Payment: 'cuota.txt',
    Product: 'producto.txt'
  }

  Dir.glob(File.expand_path("private/data") + '/' + "*.txt").each do |path|
    filename = File.basename(path)

    puts "[ Parsing #{filename} .... ========================================= ]"
    klass = files.invert[filename.downcase].to_s

    parser = "#{Parser}::#{klass}".constantize.new(path)
    parser.parse
  end
end
