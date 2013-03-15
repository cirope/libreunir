class Order < ActiveRecord::Base
  has_paper_trail
  
  # Setup accessible (or protected) attributes for your model
  attr_accessible :order_id, :adviser_id, :segment_id, :branch_id, :zone_id, :assigned_adviser_id

  # Scopes

  # Validations

  # Relations
  belongs_to :adviser
  belongs_to :branch
  belongs_to :segment
  belongs_to :zone

  # Callbacks

  # Instance or Class methods
end
