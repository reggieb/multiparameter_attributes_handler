require_relative '../lib/multiparameter_attributes_handler'

class Thing
  
  attr_reader :attributes
  
  
  def initialize
    
  end
  
  def attributes=(params)
    @attributes = MultiparameterAttributesHandler.manipulate_all(params)
  end
end

