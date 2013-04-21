module Parser
  class User < Base

    def line_save(row)
      if row_valid?(row)
        branch = ::Branch.find_by_branch_id(row[1])

        if branch.try(:persisted?)
          options = []

          row[2].downcase.split.each do |str|
            options << str.to_s.gsub(/[^a-z]/, '')
          end

          email = "#{options.compact.join('_')}@cordialnegocios.com.ar"
          password = rand(1000000..9000000)


          attributes = {
            name: row[2], username: row[0], file_number: row[6].gsub(/[^0-9]/, ''),
            identification: row[7].gsub(/[^0-9]/, ''), date_entry: row[8], 
            branch_id: branch.id, email: email, password: password, 
            password_confirmation: password
          }

          user = ::User.create(attributes)

          if user.errors.any?
            email = "#{options.compact.join('_')}_duplicado@cordialnegocios.com.ar"
            ::User.create(attributes.merge(email: email))
          end
        else
          return raise CSV::MalformedCSVError, 'Invalid row'
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
