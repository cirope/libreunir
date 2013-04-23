class Client < ActiveRecord::Base
  has_paper_trail

  # Validations
  validates :name, :lastname, :identification, presence: true
  validates :identification, uniqueness: true, allow_nil: true, allow_blank: true

  # Relations
  has_many :comments
  has_many :loans

  def to_s
    [self.lastname, self.name].compact.join(', ')
  end

  def last_comments
    self.comments.inverse_order.limit(10)
  end
end
