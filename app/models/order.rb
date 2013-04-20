class Order < ActiveRecord::Base
  has_paper_trail

  # Validations
  validates :adviser_id, presence: true

  # Relations
  belongs_to :adviser
  belongs_to :branch
  belongs_to :segment
  belongs_to :zone
  has_one :loan, primary_key: 'order_id'
  has_many :fees, through: :loan
end
