class Segment < ActiveRecord::Base
  has_paper_trail

  # Validations
  validates :segment_id, :description, :short_description, presence: true
  validates :segment_id, uniqueness: true, allow_nil: true, allow_blank: true

  # Relations
  has_many :loans
  has_many :clients, through: :loans

  def to_s
    self.short_description
  end
end
