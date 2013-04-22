class Payment < ActiveRecord::Base
  include Payments::Client
  include Payments::Scopes

  has_paper_trail

  # Validations
  validates :number, :expiration, :product_id, presence: true
  
  # Relations
  belongs_to :product
  belongs_to :user

  def expired?
    self.expiration_date < Date.today
  end
end
