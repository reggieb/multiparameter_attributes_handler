$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'multiparameter_attributes_handler'

# NB most testing of MultiparameterAttributesHandler.manipulate_all is done 
# via the thing_test.
class MultiparameterAttributesHandlerTest < Test::Unit::TestCase

  def test_manipulate_all   
    output = MultiparameterAttributesHandler.manipulate_all(attributes)
    assert_equal Time.local(2004, 6, 24), output['last_read']
  end
  
  def test_manipulate_all_with_block
    output = MultiparameterAttributesHandler.manipulate_all(attributes, &:to_s)
    assert_equal Time.local(2004, 6, 24).to_s, output['last_read']
  end
  
  def attributes
    { "last_read(1i)" => "2004", "last_read(2i)" => "6", "last_read(3i)" => "24" }
  end
  
end
