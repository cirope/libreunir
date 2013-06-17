module Parser
  class User < Base
    def process_row(row)
      user = ::User.find_by(username: row[0])
      branch = ::Branch.find_by(branch_id: row[1].to_i)

      attributes = {
        name: row[2], 
        username: row[0], 
        file_number: row[6].gsub(/[^0-9]/, ''),
        identification: row[7].gsub(/[^0-9]/, ''), 
        started_at: row[8], 
        branch_id: branch.try(:id) 
      }

      if user.try(:persisted?)
        user.without_versioning do
          user.update_attributes(attributes)
          user.touch
        end
      else
        create_user(row, attributes)
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
  end
end
