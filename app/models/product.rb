class Product < ActiveRecord::Base
  has_paper_trail

  # Setup accessible (or protected) attributes for your model
  attr_accessible :product_id, :branch_id, :delay_date, :expired_debt, :total_debt, :expired_fees, :fees_to_expire

  # Scopes                                                                                                                                                    

  # Validations
  
  # Relations
  belongs_to :branch

  # Callbacks

  # Instance or Class methods

end
