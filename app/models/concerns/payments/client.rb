module Payments::Client
  extend ActiveSupport::Concern

  included do
    delegate :phone, :address, :last_comments, to: :client, prefix: true, allow_nil: true
    has_one :client, through: :loan
  end
end
