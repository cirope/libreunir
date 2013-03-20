class Branch < ActiveRecord::Base
  has_paper_trail

  # Setup accessible (or protected) attributes for your model
  # Deprecated in rails 4                                                                                                                                                
  # attr_accessible :zone_id, :name

  # Scopes                                                                                                                                                    

  # Validations
  
  # Relations
  belongs_to :zone
  has_many :advisers

  # Callbacks

  # Instance or Class methods

end
