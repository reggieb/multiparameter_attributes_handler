$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require_relative '../../lib/multiparameter_attributes_handler'

module MultiparameterAttributesHandler
  class ManipulatorTest < Test::Unit::TestCase

    def test_multiparameters
      assert_equal ['last_read', 'other'], manipulator.multiparameters
    end

    def test_values_for
      assert_equal hash['foo'], manipulator.values_for('foo')
    end

    def test_values_for_multiparameter
      assert_equal ['2004', '6', '24'], manipulator.values_for('last_read')
    end

    def test_value_of
      assert_equal hash['foo'], manipulator.value_of('foo')
    end

    def test_value_of_multiparameter
      assert_equal time_for('other'), manipulator.value_of('other')
    end

    def test_value_mod_changes_values
      manipulator = Manipulator.new(hash, &:to_s)
      assert_equal date_for('last_read').to_s, manipulator.value_of('last_read')
    end

    def test_value_of_multiparameter_when_date
      assert_equal date_for('last_read'), @manipulator.value_of('last_read')
    end
    
    def test_value_mod_with_lambda
      manipulator = Manipulator.new(hash) {|value| value + 1}
      assert_equal (date_for('last_read') + 1), manipulator.value_of('last_read')
    end

    def test_output_returns_original_content
      build_manipulator
      hash.each do |key, value|
        assert_equal value, output[key]
      end
    end

    def test_output_returns_multiparameter_content_and_original_content
      combined_length = original.length + manipulator.multiparameters.length
      assert_equal combined_length, output.length
    end

    def test_output_returns_multiparameter_content
      manipulator.multiparameters.each do |multiparameter|
        assert_equal manipulator.value_of(multiparameter), output[multiparameter]
      end
    end

    def test_output_manipulates_hash
      build_manipulator
      assert_not_equal(original, hash)
      assert_equal output, hash
    end

    def test_partial_multiparameters_are_ignored
      [
        {"last_read(1i)" => "2004", "last_read(2i)" => "6", "last_read(3i)" => ""},
        {"last_read(1i)" => "2004", "last_read(2i)" => "", "last_read(3i)" => "24"},
        {"last_read(1i)" => "", "last_read(2i)" => "6", "last_read(3i)" => "24"}
      ].each do |params|
        assert_equal [], Manipulator.new(params).multiparameters, "#{params.inspect} should return []"
      end
    end

    def hash
      @hash ||= {
        "last_read(1i)" => "2004",
        "last_read(2i)" => "6",
        "last_read(3i)" => "24",
        "other(1i)" => "2012",
        "other(2i)" => "2",
        "other(3i)" => "2",
        "other(4i)" => "11",
        "other(5i)" => "35",
        "foo" => 'bar',
        "something" => 'ho',
        "something_else" => 'hum'
      }
    end

    def original
      @original ||= hash.clone
    end

    def manipulator
      @manipulator ||= Manipulator.new(hash)
    end

    def build_manipulator
      original # make sure original is generated before manipulator built
      output   # use output to create manipulator to ensure all objects built
    end

    def output
      manipulator.output
    end
    
    def time_for(field)
      Time.local *manipulator.values_for(field)
    end

    def date_for(field)
      Date.new *manipulator.values_for(field).collect(&:to_i)
    end

  end
end
