class Zone < ActiveRecord::Base
  has_paper_trail

  # Setup accessible (or protected) attributes for your model  
  attr_accessible :name

  # Scopes                                                                                                                                                    

  # Validations
  
  # Relations
  has_many :branches

  # Callbacks                                                                                                                                                 

  # Instance or Class methods

end
