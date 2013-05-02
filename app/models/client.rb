class Client < ActiveRecord::Base
  include Clients::MagickColumns

  has_paper_trail

  # Validations
  validates :name, :lastname, :identification, presence: true
  validates :identification, uniqueness: true, allow_nil: true, allow_blank: true

  # Relations
  has_many :loans
  has_many :comments, dependent: :destroy
  has_many :schedules, as: :schedulable, dependent: :destroy

  def to_s
    [self.lastname, self.name].compact.join(', ')
  end

  def last_comments
    self.comments.inverse_order.limit(10)
  end

  def is_scheduled?
    self.schedules.present?
  end
end
