class Client < ActiveRecord::Base
  has_paper_trail

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :segment, :identification, :product_id

  # Scopes

  # Validations

  # Relations
  has_many :loans, primary_key: 'product_id'
  has_many :fees, primary_key: 'product_id', inverse_of: :client
  has_many :addresses, primary_key: 'product_id'
  has_many :calls, primary_key: 'product_id'
  has_many :orders

  # Callbacks

  # Instance or Class methods

end
