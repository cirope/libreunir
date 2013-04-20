class Fee < ActiveRecord::Base
  include Fees::Delayed

  has_paper_trail

  # Delegations
  delegate :calls, :phones, :addresses, to: :client, prefix: true, allow_nil: false

  # Scopes
  default_scope -> { order("#{table_name}.expiration_date ASC") }

  # Validations
  validates :loan_id, presence: true

  # Relations
  belongs_to :loan, primary_key: 'order_id'
  has_one :client, through: :loan
end
