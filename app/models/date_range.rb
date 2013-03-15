class DateRange 
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming 

  attr_accessor :start, :end

  validates :start, timeliness: { type: :date }, allow_nil: true,
    allow_blank: true
  validates :end, timeliness: { after: :start, type: :date },
    allow_nil: true, allow_blank: true

  def initialize(attributes)
    attributes ||= {}
    @start = Timeliness.parse(attributes['start']).try(:to_date) || Date.today
    @end = Timeliness.parse(attributes['end']).try(:to_date) || Timeliness.parse(1.week.from_now).try(:to_date)
  end
  
  def persisted?
    false
  end
end
