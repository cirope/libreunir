class Product < ActiveRecord::Base
  has_paper_trail

  # Scopes

  # Validations
  validates :product_id, presence: true
  validates :product_id, uniqueness: true, allow_nil: true, allow_blank: true

  # Relations
  belongs_to :client
  belongs_to :branch
  has_many :payments, dependent: :destroy
end
