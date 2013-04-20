class Loan < ActiveRecord::Base
  has_paper_trail

  # Validations
  validates :order_id, presence: true

  # Relations
  belongs_to :adviser
  belongs_to :client, primary_key: 'product_id', foreign_key: 'order_id'
  belongs_to :fund
  belongs_to :product
  has_many :fees, primary_key: 'order_id'
end
