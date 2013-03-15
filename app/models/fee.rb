class Fee < ActiveRecord::Base
  has_paper_trail

  # TODO: remove product_id, is replaced by client_id
  # Setup accessible (or protected) attributes for your model
  attr_accessible :loan, :amount, :expiration_date, :payment_date, :product_id, :fee_number, :total_amount, :client_id

  # Scopes
  default_scope order('expiration_date ASC')

  # Validations

  # Relations
  belongs_to :client, primary_key: 'product_id', inverse_of: :fees
  belongs_to :loan, primary_key: 'product_id'

  # Callbacks

  # Instance or Class methods

end
