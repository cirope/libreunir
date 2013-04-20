module Parser
  class User < Base

    def line_save(row)
      if row_valid?(row)
        options = []

        row[2].to_s.downcase.split.each do |str|
          options << str.to_s.gsub(/[^a-z]/, '')
        end

        email = "#{options.compact.join('_')}@cordialnegocios.com.ar"
        password = rand(1000000..9000000)

        attributes = {
          adviser_id: row[0], branch_id: row[1].to_i, name: row[2],
          identification: row[7].to_s.gsub('(null)', ''), 
          bundle: row[6].to_s.gsub('(null)', ''), email: email,
          password: password, password_confirmation: password
        }

        user = ::User.create(attributes)

        if user.errors.any?
          email = "#{options.compact.join('_')}_duplicado@cordialnegocios.com.ar"
          ::User.create(attributes.merge(email: email))
        end
      end
    end

    def row_valid?(row)
      ['Job', 'UsuarioID', '---'].each do |str|
        if row[0].start_with?(str)
          return raise CSV::MalformedCSVError, 'Invalid row'
        end
      end
      
      true
    end
  end
end
