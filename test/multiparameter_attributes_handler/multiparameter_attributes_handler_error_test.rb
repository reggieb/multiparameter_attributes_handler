$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require_relative '../../lib/multiparameter_attributes_handler'

module MultiparameterAttributesHandler
  class MultiparameterAttributesHandlerErrorTest < Test::Unit::TestCase

    def test_error
      assert_raise RuntimeError do
        raise "Oh yes"
      end
    end

    def test_attribute_assignment_error
      error = assert_raise AttributeAssignmentError do
        raise AttributeAssignmentError.new('b', 'c'), 'd'
      end
      assert_equal('d', error.message)
      assert_equal('b', error.exception_raised)
      assert_equal('c', error.attribute_name)
    end

  end
end
