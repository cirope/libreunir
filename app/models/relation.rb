class Relation < ActiveRecord::Base
  has_paper_trail
  TYPE = ['superior', 'dependent', 'other']

  # Setup accessible (or protected) attributes for your model
  # Deprecated in rails 4
  # attr_accessible :relation, :user_id, :relative_id

  attr_accessor :auto_user_name

  # Scopes

  # Validations
  validates :relation, :relative_id, presence: true
  validates :relation, length: { maximum: 255 }, allow_nil: true, allow_blank: true
  validates :relation, inclusion: { in: TYPE }, allow_nil: true, allow_blank: true

  # Relations
  belongs_to :user
  belongs_to :relative, class_name: 'User'

  # Callbacks
  TYPE.each do |relation|
    define_method("#{relation}?") { self.relation == relation }
  end

  # Instance or Class methods

end
