class Zone < ActiveRecord::Base
  has_paper_trail

  # Validations
  validates :name, :zone_id, :branch_id, presence: true
  validates :name, uniqueness: { case_sensitive: false, scope: [:zone_id, :branch_id] },
    allow_nil: true, allow_blank: true
  validates :name, :zone_id, length: { maximum: 255 }, allow_nil: true, allow_blank: true

  # Relations
  belongs_to :branch
  has_many :loans
  has_many :users, through: :loans

  def to_s
    self.name
  end

  def self.filter_by_loans(loans)
    joins(:loans).where(
      "#{Loan.table_name}.id" => loans.pluck("#{Loan.table_name}.id")
    ).order("#{table_name}.name ASC").uniq
  end
end
