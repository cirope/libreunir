module Loans::Client
  extend ActiveSupport::Concern

  included do
    delegate :address, :last_comments, to: :client, prefix: true, allow_nil: true
    belongs_to :client
    has_many :phones, through: :client
  end

  def client_phones
    self.phones.order("#{Phone.table_name}.created_at ASC").join(' - ')
  end
end
