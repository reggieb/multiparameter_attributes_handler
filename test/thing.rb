
class Parent
  attr_accessor :attributes
end


class Thing < Parent

  
  include MultiparameterAttributesHandler
  
  def initialize
    
  end
end

