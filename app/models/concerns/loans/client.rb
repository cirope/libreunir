module Loans::Client
  extend ActiveSupport::Concern

  included do
    delegate :phones, :address, :last_comments, to: :client, prefix: true, allow_nil: true
    belongs_to :client
    has_many :phones, through: :client
  end
end
