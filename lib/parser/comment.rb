module Parser
  class Comment
    def self.parse(row, client)
      (5..7).each do |x|
        if row[x].to_s.gsub(/[^a-z]/, '').present?
          xrow = row[x].split('-').map { |field| field.strip }

          user = User.where(username: xrow[1]).first

          ::Comment.create(
            comment: xrow[2], client_id: client.id, 
            user_id: user.id, created_at: Time.parse(xrow[0])
          ) if user.try(:persisted?)
        end
      end
    end
  end
end
