class Zone < ActiveRecord::Base
  include Filters

  has_paper_trail

  # Validations
  validates :name, presence: true
  validates :name, uniqueness: { case_sensitive: false }, allow_nil: true, allow_blank: true
  validates :name, length: { maximum: 255 }, allow_nil: true, allow_blank: true

  # Relations
  has_many :loans
  has_many :users, through: :loans

  def to_s
    self.name
  end

  def self.find_by_loans(loans)
    where(id: loans.pluck('zone_id')).order("#{table_name}.name ASC")
  end
end
