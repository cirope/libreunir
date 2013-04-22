module Payments::Client
  extend ActiveSupport::Concern

  included do
    delegate :phone, :address, to: :client, prefix: true, allow_nil: true
    has_one :client, through: :product
  end
end
