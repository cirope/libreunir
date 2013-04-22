class Client < ActiveRecord::Base
  has_paper_trail

  # Validations
  validates :name, :lastname, :identification, presence: true
  # TODO: improve the validation of identification
  validates :identification, uniqueness: true, allow_nil: true, allow_blank: true

  # Relations
  has_many :comments
  has_many :loans

  def last_comments
    self.comments.inverse_order.limit(10)
  end
end
