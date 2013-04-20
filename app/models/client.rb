class Client < ActiveRecord::Base
  has_paper_trail

  # Validations
  validates :product_id, presence: true
  validates :product_id, uniqueness: true, allow_nil: true, allow_blank: true

  # Relations
  has_many :loans, primary_key: 'product_id'
  has_many :fees, primary_key: 'product_id', foreign_key: 'loan_id', inverse_of: :client
  has_many :addresses, primary_key: 'product_id', inverse_of: :client
  has_many :phones, primary_key: 'product_id', inverse_of: :client
  has_many :calls, primary_key: 'product_id'
  has_many :orders
end
