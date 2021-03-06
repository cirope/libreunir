module Loans::Client
  extend ActiveSupport::Concern

  included do
    delegate :address, to: :client, prefix: true, allow_nil: true

    belongs_to :client
    has_many :phones, through: :client
    has_many :comments, dependent: :destroy
  end

  def last_comments
    self.comments.inverse_order.limit(10)
  end

  def address
    self.client_address
  end
end
