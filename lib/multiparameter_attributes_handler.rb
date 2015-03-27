require_relative 'multiparameter_attributes_handler/manipulator'
require_relative 'multiparameter_attributes_handler/multiparameter_attributes_handler_error'
module MultiparameterAttributesHandler
  
  def self.manipulate_all(hash, &value_mod)
    Manipulator.new(hash, &value_mod).output
  end
    
end
