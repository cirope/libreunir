class Filter
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  extend ActiveModel::Translation

  attr_accessor :start, :user_id, :auto_user_name

  validates :start, timeliness: { type: :date }, allow_nil: true,
    allow_blank: true

  def initialize(attributes = {})
    @start   = Timeliness.parse(attributes[:start]).try(:to_date) || Date.today
    @user_id = attributes['user_id']
  end

  def persisted?
    false
  end
end
