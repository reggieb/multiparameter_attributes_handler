

module MultiparameterAttributesHandler
  class Manipulator
    
    attr_accessor :hash
    
    def initialize(hash)
      @hash = hash
    end
    
    def multiparameters
      keys = multiparameter_keys.collect do |k| 
        k.gsub(ends_with_number_letter_in_brackets, "")
      end
      keys.uniq!
      keys.delete_if{|k| empty_values_for? k}
      return keys
    end
    
    def values_for(multiparameter)
      return hash[multiparameter] unless multiparameters.include? multiparameter
      keys_for(multiparameter).collect{|k| hash[k]}
    end
    
    def value_of(multiparameter)
      values = values_for(multiparameter)
      return values unless values.kind_of? Array
      Time.local(*values)
    end
    
    def output
      multiparameters.each do |multiparameter|
        hash[multiparameter] = value_of(multiparameter)
      end
      hash
    end
    
    private
    def ends_with_number_letter_in_brackets
      /\(\d+\w+\)$/
    end
    
    def multiparameter_keys
      hash.keys.select{|k| k =~ ends_with_number_letter_in_brackets}
    end
    
    def keys_for(multiparameter)
      multiparameter_keys.select{|k| /^#{multiparameter}\(/ =~ k}
    end
    
    def empty_values_for?(multiparameter)
      !keys_for(multiparameter).select{|p| hash[p].empty?}.empty?
    end
  end
end
