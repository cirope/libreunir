class Loan < ActiveRecord::Base
  has_paper_trail

  # Setup accessible (or protected) attributes for your model
  # Deprecated in rails 4                                                                                                                                                
  # attr_accessible :client_id, :adviser_id, :amount, :grant_date, :expiration_date, :product_id, :fund_id, :amount_to_finance, :capital, :number_of_fees

  # Scopes

  # Validations

  # Relations
  belongs_to :adviser
  belongs_to :client, primary_key: 'product_id'
  belongs_to :fund
  belongs_to :product

  # Callbacks

  # Instance or Class methods

end
