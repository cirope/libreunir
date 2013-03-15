class Segment < ActiveRecord::Base
  has_paper_trail

  # Setup accessible (or protected) attributes for your model
  attr_accessible :segment_id, :description, :status

  # Scopes                                                                                                                                                    

  # Validations
  
  # Relations

  # Callbacks

  # Instance or Class methods

end
