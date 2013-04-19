class Address < ActiveRecord::Base
  has_paper_trail

  # Setup accessible (or protected) attributes for your model
  # Deprecated in rails 4
  # attr_accessible :address, :street, :number, :floor, :location, :postal_code, :product_id

  # Scopes

  # Validations
  validates :address, presence: true
  validates :address, uniqueness: { scope: :client_id, case_sensitive: false }, 
    allow_nil: true, allow_blank: true

  # Relations
  belongs_to :client, primary_key: 'product_id'

  # Callbacks

  # Instance or Class methods

end
