class Zone < ActiveRecord::Base
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

  def loans_count(loans)
    self.loans.where(id: loans.map(&:id)).count
  end
  
  def expired(loans)
    self.loans.where(id: loans.map(&:id)).expired.count
  end

  def close_to_expire(loans)
    self.loans.where(id: loans.map(&:id)).not_expired.with_expiration.policy.count
  end

  def total_debt(loans)
    self.loans.where(id: loans.map(&:id)).map(&:total_debt).reduce(:+)
  end

  def self.find_by_loans(loans)
    where("#{table_name}.id" => loans.map(&:zone_id)).order("#{table_name}.name ASC")
  end
end
