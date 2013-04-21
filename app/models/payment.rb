class Payment < ActiveRecord::Base
  has_paper_trail

  # Setup accessible (or protected) attributes for your model
  #attr_accessible :number, :expiration, :payment_date, :amount_paid, :total, :product, :user

  # Scopes                                                                                                                                                    
  # Validations
  validates :number, :expiration, :product_id, :user_id, presence: true
  
  # Relations
  belongs_to :product
  belongs_to :user
end
