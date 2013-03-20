class Adviser < ActiveRecord::Base
  has_paper_trail

  # Setup accessible (or protected) attributes for your model
  # Deprecated in rails 4                                                                                                                                                
  # attr_accessible :adviser_id, :branch_id, :description, :bundle, :name, :identification, :product_id

  # Scopes                                                                                                                                                    

  # Validations
  
  # Relations
  belongs_to :branch
  has_many :loans, primary_key: 'product_id'
  has_many :clients, primary_key: 'product_id'

  # Callbacks

  # Instance or Class methods



end
