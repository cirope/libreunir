module Parser
  class Comment
    def initialize(row, client)
      @row = row
      @client = client
    end

    def parse
      [5, 6, 7].each do |idx|
        c_row = @row[idx].to_s.split('-')

        if c_row.length == 3
          c_row.map! { |r| r.strip }

          process(c_row)
        end
      end
    end

    private

    def process(c_row)
      user = ::User.find_by(username: c_row[1])

      @client.comments.find_or_create_by(
        comment: c_row[2], user_id: user.id, created_at: Time.parse(c_row[0])
      ) if user.try(:persisted?)
    end
  end
end
