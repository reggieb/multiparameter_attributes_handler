require_relative 'multiparameter_attributes_handler/manipulator'
require_relative 'multiparameter_attributes_handler/multiparameter_attributes_handler_error'
module MultiparameterAttributesHandler
  
  def self.manipulate_all(hash)
    Manipulator.new(hash).output
  end
    
end
