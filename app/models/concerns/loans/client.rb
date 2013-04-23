module Loans::Client
  extend ActiveSupport::Concern

  included do
    delegate :phone, :address, :last_comments, to: :client, prefix: true, allow_nil: true
    belongs_to :client
  end
end
