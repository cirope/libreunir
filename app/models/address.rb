class Address < ActiveRecord::Base
  has_paper_trail

  # Validations
  validates :address, presence: true
  validates :address, uniqueness: { scope: :client_id, case_sensitive: false }, 
    allow_nil: true, allow_blank: true

  # Relations
  belongs_to :client, primary_key: 'product_id'

  def to_s
    self.address
  end
end
