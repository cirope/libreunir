require_relative '../parser/base'

task parser: :environment do

  files = {
    Client: 'clientes.txt',
    Fee: 'cuota.txt',
    Loan: 'prestamo.txt',
    Product: 'producto.txt',
    Segment: 'segmento.txt',
    Order: 'solicitud.txt',
    Branch: 'sucursal.txt',
    User: 'usuario.txt'
  }

  Dir.glob(File.expand_path("private/data") + '/' + "*.txt").each do |path|
    filename = File.basename(path)

    puts "[ Parsing #{filename} .... ========================================= ]"
    klass = files.invert[filename.downcase].to_s

    parser = "#{Parser}::#{klass}".constantize.new(path)
    parser.parse
  end
end
