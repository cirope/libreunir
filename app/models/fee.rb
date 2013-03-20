class Fee < ActiveRecord::Base
  has_paper_trail

  # Setup accessible (or protected) attributes for your model
  # Deprecated in rails 4                                                                                                                                                
  # attr_accessible :loan, :amount, :expiration_date, :payment_date, :product_id, :fee_number, :total_amount, :client_id

  # Scopes
  default_scope -> { order('expiration_date ASC') }

  # Validations

  # Relations
  belongs_to :client, primary_key: 'product_id', inverse_of: :fees
  belongs_to :loan, primary_key: 'product_id'

  # Callbacks

  # Instance or Class methods
  def self.filtered_list(query)
    query.present? ? magick_search(query) : all                                                                                                                          
  end

  def late_average
    fees = self.class.where("payment_date IS NOT NULL AND client_id = ?", self.client_id)
    days = 0
    fees.each do |fee|
      days += (fee.expiration_date.to_date - fee.payment_date.to_date)
    end
    if days < 0
      formal = 'late'
      days = -days
    else
      formal = 'in_time'
    end
    { formal: formal ,days: (days/fees.count) }
  end
end
