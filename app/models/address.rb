class Address < ActiveRecord::Base
  has_paper_trail

  # Setup accessible (or protected) attributes for your model
  attr_accessible :address, :street, :number, :floor, :location, :postal_code, :product_id
  
  # Scopes

  # Validations

  # Relations
  belongs_to :client, primary_key: 'product_id'

  # Callbacks

  # Instance or Class methods

end
