class Address < ActiveRecord::Base
  has_paper_trail

  # Validations
  validates :address, presence: true

  # Relations
  belongs_to :client, primary_key: 'product_id'

  def to_s
    self.address
  end
end
