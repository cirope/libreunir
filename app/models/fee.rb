class Fee < ActiveRecord::Base
  has_paper_trail

  # Setup accessible (or protected) attributes for your model
  # Deprecated in rails 4                                                                                                                                                
  # attr_accessible :loan, :amount, :expiration_date, :payment_date, :product_id, :fee_number, :total_amount, :client_id

  # Scopes
  default_scope -> { order('expiration_date ASC') }

  # Validations

  # Relations
  belongs_to :client, primary_key: 'product_id', inverse_of: :fees
  belongs_to :loan, primary_key: 'product_id'

  # Callbacks

  # Instance or Class methods

end
