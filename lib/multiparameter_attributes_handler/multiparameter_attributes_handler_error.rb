
module MultiparameterAttributesHandler
  
  class MultiparameterAttributesHandlerError < StandardError

  end
  
  # Raised when an error occurred while doing a mass assignment to an attribute through the
  # <tt>attributes=</tt> method. The exception has an +attribute_name+ property that is 
  # the name of the offending attribute.
  class AttributeAssignmentError < MultiparameterAttributesHandlerError
    attr_reader :exception_raised, :attribute_name
    def initialize(exception_raised, attribute_name)
      @exception_raised = exception_raised
      @attribute_name = attribute_name
    end
  end

  # Raised when there are multiple errors while doing a mass assignment through the +attributes+
  # method. The exception has an +errors+ property that contains an array of AttributeAssignmentError
  # objects, each corresponding to the error while assigning to an attribute.
  class MultiparameterAssignmentErrors < MultiparameterAttributesHandlerError
    attr_reader :errors
    def initialize(errors)
      @errors = errors
    end
    
  end
end
