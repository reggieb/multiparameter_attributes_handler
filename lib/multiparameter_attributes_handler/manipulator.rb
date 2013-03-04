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
      keys.delete_if{|k| empty_date_values_for? k}
      return keys
    end
    
    def values_for(multiparameter)
      return hash[multiparameter] unless multiparameters.include? multiparameter
      keys_for(multiparameter).collect{|k| hash[k]}
    end
    
    def value_of(multiparameter)
      values = values_for(multiparameter)
      return values unless values.kind_of? Array
      begin
        Time.local(*values)
      rescue => e
        msg = "Error determining value_of #{multiparameter} from #{values} (#{e.message})"
        raise_assignment_errors(multiparameter, values, msg, e)
      end
    end
    
    def output
      begin
        multiparameters.each do |multiparameter|
          hash[multiparameter] = value_of(multiparameter)
        end
      rescue => e
        errors << e
      end
      return hash if errors.empty?
      
      error_descriptions = errors.collect { |ex| ex.message }.join(",")
      msg = "#{errors.size} error(s) on determining value of multiparameter attributes [#{error_descriptions}]"
      raise MultiparameterAssignmentErrors.new(errors), msg
    end
    
    private
    def ends_with_number_letter_in_brackets
      /\(\d+\w+\)$/
    end
    
    def multiparameter_keys
      hash.keys.select{|k| k =~ ends_with_number_letter_in_brackets}
    end
    
    def keys_for(multiparameter)
      keys = multiparameter_keys.select{|k| /^#{multiparameter}\(/ =~ k}
      match = keys.first.match(/\(\d+(\w*)\)/)
      postscript = match ? match[1] : ""
      numbers = sequence_numbers(keys)
      (1..numbers.last).each do |number|
        next if number < 3
        next if numbers.include? number
        key = "#{multiparameter}(#{number}#{postscript})"
        hash[key] = '00'
        keys << key
      end
      raise_assignment_errors(
        multiparameter, 
        keys, 
        "key number sequence incomplete or not starting at one"
      ) unless sequence_starting_at_one?(keys)
      keys.sort
    end
    
    def empty_date_values_for?(multiparameter)
      keys = keys_for(multiparameter)[0..2].select{|p| hash[p].empty?}
      !keys.empty?
    end
    
    def sequence_starting_at_one?(keys)
      numbers = sequence_numbers(keys)
      expected = (1..10).to_a
      numbers == expected[0..(numbers.length - 1)]
    end
    
    def sequence_numbers(keys)
      keys.collect{|k| m = k.match(/\((\d+)\w+\)/); m ? m[1].to_i : nil}.sort
    end
    
    def errors
      @errors ||= []
    end
    
    def raise_assignment_errors(multiparameter, values, message, error = StandardError)
      msg = "Error determining value_of #{multiparameter} from #{values} (#{message})"
      raise AttributeAssignmentError.new(error, multiparameter), msg
    end
  end
end
