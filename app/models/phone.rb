class Phone < ActiveRecord::Base
  has_paper_trail

  # Scopes
  default_scope { order("#{table_name}.created_at ASC") }

  # Validations
  validates :phone, presence: true
  validates :phone, length: { maximum: 255 }, allow_nil: true, allow_blank: true
  validates :phone, uniqueness: { case_sensitive: false, scope: :client_id }, 
    allow_nil: true, allow_blank: true

  # Relations
  belongs_to :client

  def to_s
    self.phone
  end
end
