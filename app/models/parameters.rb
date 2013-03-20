class Parameters < ActiveRecord::Base
  has_paper_trail

  # Setup accessible (or protected) attributes for your model
  # Deprecated in rails 4
  # attr_accessible :rate

  # Scopes

  # Validations
  validates :rate, presence: true

  # Relations

  # Callbacks

  # Instance or Class methods

end
