class Payment < ActiveRecord::Base
  include Payments::Calculations
  include Payments::Client
  include Payments::Scopes

  has_paper_trail

  # Validations
  validates :number, :expiration, :product_id, presence: true
  
  # Relations
  belongs_to :product
  belongs_to :user
end
