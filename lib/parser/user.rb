module Parser
  class User < Base

    def line_save(row)
      if row_valid?(row)
        user = ::User.find_by(username: row[0])
        branch = ::Branch.find_by(branch_id: row[1])

        attributes = {
          name: row[2], 
          username: row[0], 
          file_number: row[6].gsub(/[^0-9]/, ''),
          identification: row[7].gsub(/[^0-9]/, ''), 
          started_at: row[8], 
          branch_id: branch.try(:id) 
        }

        if user.try(:persisted?)
          user.update_attributes(attributes)
          user.touch
        else
          create_user(row, attributes)
        end
      end
    end

    def create_user(row, attributes)
      options = []
      row[2].downcase.split.each { |str| options << str.to_s.gsub(/[^a-z]/, '') }
      email = "#{options.compact.join('_')}@cordialnegocios.com.ar"
      password = rand(1000000..9000000)

      attributes.merge!(email: email, password: password, password_confirmation: password)
      user = ::User.create(attributes)

      if user.errors.any?
        email = "#{options.compact.join('_')}_duplicado@cordialnegocios.com.ar"
        ::User.create(attributes.merge(email: email))
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
