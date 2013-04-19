class Phone < ActiveRecord::Base
  has_paper_trail

  # Setup accessible (or protected) attributes for your model
  # Deprecated in rails 4
  # attr_accessible :client_id, :number

  # Scopes

  # Validations
  validates :client_id, presence: true
  validates :phone, uniqueness: { scope: :client_id, case_sensitive: false }, 
    allow_nil: true, allow_blank: true

  # Relations
  belongs_to :client, primary_key: 'product_id'

  # Callbacks

  # Instance or Class methods

end
