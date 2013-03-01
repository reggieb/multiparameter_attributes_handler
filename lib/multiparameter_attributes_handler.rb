require_relative 'multiparameter_attributes_handler/manipulator'
module MultiparameterAttributesHandler
  
  def attributes=(new_attributes)
    super Manipulator.new(new_attributes).output
  end
    
end
