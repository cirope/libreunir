class Order < ActiveRecord::Base
  has_paper_trail

  # Setup accessible (or protected) attributes for your model
  # Deprecated in rails 4
  # attr_accessible :order_id, :adviser_id, :segment_id, :branch_id, :zone_id, :assigned_adviser_id

  # Scopes

  # Validations
  validates :adviser_id, presence: true

  # Relations
  belongs_to :adviser
  belongs_to :branch
  belongs_to :segment
  belongs_to :zone
  has_one :loan, primary_key: 'order_id'
  has_many :fees, through: :loan

  # Callbacks

  # Instance or Class methods
end
