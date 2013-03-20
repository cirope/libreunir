class Fee < ActiveRecord::Base
  include Fees::Delayed

  has_paper_trail
  # Setup accessible (or protected) attributes for your model
  # Deprecated in rails 4
  # attr_accessible :loan, :amount, :expiration_date, :payment_date, :product_id, :fee_number, :total_amount, :client_id

  # Scopes
  default_scope -> { order('expiration_date ASC') }

  # Validations
  validates :loan_id, presence: true

  # Relations
  belongs_to :loan, primary_key: :order_id
  has_one :client, through: :loan

  # Callbacks


end
