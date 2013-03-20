class Segment < ActiveRecord::Base
  has_paper_trail

  # Setup accessible (or protected) attributes for your model
  # Deprecated in rails 4
  # attr_accessible :segment_id, :description, :status

  # Scopes

  # Validations
  validates :segment_id, presence: true
  validates :description, uniqueness: true, allow_nil: true, allow_blank: true

  # Relations

  # Callbacks

  # Instance or Class methods

end
