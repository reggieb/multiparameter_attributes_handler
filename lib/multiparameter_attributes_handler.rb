require_relative 'multiparameter_attributes_handler/manipulator'
require_relative 'multiparameter_attributes_handler/multiparameter_attributes_handler_error'
module MultiparameterAttributesHandler
  
  def attributes=(new_attributes)
    super Manipulator.new(new_attributes).output
  end
    
end
