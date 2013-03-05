$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'date'
require_relative 'thing'

class ThingTest < Test::Unit::TestCase
  
  def setup
    @thing = Thing.new
  end
  
  def test_multiparameter_attributes_on_date
    attributes = { "last_read(1i)" => "2004", "last_read(2i)" => "6", "last_read(3i)" => "24" }
    @thing.attributes = attributes
    # note that extra #to_date call allows test to pass for Oracle, which
    # treats dates/times the same
    assert_equal Time.local(2004, 6, 24), @thing.attributes['last_read']
  end

  def test_multiparameter_attributes_on_date_with_empty_year
    attributes = { "last_read(1i)" => "", "last_read(2i)" => "6", "last_read(3i)" => "24" }
    @thing.attributes = attributes
    # note that extra #to_date call allows test to pass for Oracle, which
    # treats dates/times the same
    assert_nil @thing.attributes['last_read']
  end

  def test_multiparameter_attributes_on_date_with_empty_month
    attributes = { "last_read(1i)" => "2004", "last_read(2i)" => "", "last_read(3i)" => "24" }
    @thing.attributes = attributes
    # note that extra #to_date call allows test to pass for Oracle, which
    # treats dates/times the same
    assert_nil @thing.attributes['last_read']
  end

  def test_multiparameter_attributes_on_date_with_empty_day
    attributes = { "last_read(1i)" => "2004", "last_read(2i)" => "6", "last_read(3i)" => "" }
    @thing.attributes = attributes
    # note that extra #to_date call allows test to pass for Oracle, which
    # treats dates/times the same
    assert_nil @thing.attributes['last_read']
  end

  def test_multiparameter_attributes_on_date_with_empty_day_and_year
    attributes = { "last_read(1i)" => "", "last_read(2i)" => "6", "last_read(3i)" => "" }
    @thing.attributes = attributes
    # note that extra #to_date call allows test to pass for Oracle, which
    # treats dates/times the same
    assert_nil @thing.attributes['last_read']
  end

  def test_multiparameter_attributes_on_date_with_empty_day_and_month
    attributes = { "last_read(1i)" => "2004", "last_read(2i)" => "", "last_read(3i)" => "" }
    @thing.attributes = attributes
    # note that extra #to_date call allows test to pass for Oracle, which
    # treats dates/times the same
    assert_nil @thing.attributes['last_read']
  end

  def test_multiparameter_attributes_on_date_with_empty_year_and_month
    attributes = { "last_read(1i)" => "", "last_read(2i)" => "", "last_read(3i)" => "24" }
    @thing.attributes = attributes
    # note that extra #to_date call allows test to pass for Oracle, which
    # treats dates/times the same
    assert_nil @thing.attributes['last_read']
  end

  def test_multiparameter_attributes_on_date_with_all_empty
    attributes = { "last_read(1i)" => "", "last_read(2i)" => "", "last_read(3i)" => "" }
    @thing.attributes = attributes
    assert_nil @thing.attributes['last_read']
  end

  def test_multiparameter_attributes_on_time
    attributes = {
      "written_on(1i)" => "2004", "written_on(2i)" => "6", "written_on(3i)" => "24",
      "written_on(4i)" => "16", "written_on(5i)" => "24", "written_on(6i)" => "00"
    }
    @thing.attributes = attributes
    assert_equal Time.local(2004, 6, 24, 16, 24, 0), @thing.attributes['written_on']
  end

  def test_multiparameter_attributes_on_time_with_no_date
    ex = assert_raise(MultiparameterAttributesHandler::MultiparameterAssignmentErrors) do
      attributes = {
        "written_on(4i)" => "16", "written_on(5i)" => "24", "written_on(6i)" => "00"
      }
      @thing.attributes = attributes
    end
    assert_equal("written_on", ex.errors[0].attribute_name)
  end

  def test_multiparameter_attributes_on_time_with_invalid_time_params
    ex = assert_raise(MultiparameterAttributesHandler::MultiparameterAssignmentErrors) do
      attributes = {
        "written_on(1i)" => "2004", "written_on(2i)" => "6", "written_on(3i)" => "24",
        "written_on(4i)" => "2004", "written_on(5i)" => "36", "written_on(6i)" => "64",
      }
      @thing.attributes = attributes
    end
    assert_equal("written_on", ex.errors[0].attribute_name)
  end

  def test_multiparameter_attributes_on_time_with_old_date
    attributes = {
      "written_on(1i)" => "1850", "written_on(2i)" => "6", "written_on(3i)" => "24",
      "written_on(4i)" => "16", "written_on(5i)" => "24", "written_on(6i)" => "00"
    }
    @thing.attributes = attributes
    # testing against to_s(:db) representation because either a Time or a DateTime might be returned, depending on platform
    assert_equal "1850-06-24 16:24:00", @thing.attributes['written_on'].strftime("%Y-%m-%d %H:%M:%S")
  end

  def test_multiparameter_attributes_on_time_will_raise_on_big_time_if_missing_date_parts
    ex = assert_raise(MultiparameterAttributesHandler::MultiparameterAssignmentErrors) do
      attributes = {
        "written_on(4i)" => "16", "written_on(5i)" => "24"
      }
      @thing.attributes = attributes
    end
    assert_equal("written_on", ex.errors[0].attribute_name)
  end

  def test_multiparameter_attributes_on_time_with_raise_on_small_time_if_missing_date_parts
    ex = assert_raise(MultiparameterAttributesHandler::MultiparameterAssignmentErrors) do
      attributes = {
        "written_on(4i)" => "16", "written_on(5i)" => "12", "written_on(6i)" => "02"
      }
      @thing.attributes = attributes
    end
    assert_equal("written_on", ex.errors[0].attribute_name)
  end

  def test_multiparameter_attributes_on_time_will_ignore_hour_if_missing
    attributes = {
      "written_on(1i)" => "2004", "written_on(2i)" => "12", "written_on(3i)" => "12",
      "written_on(5i)" => "12", "written_on(6i)" => "02"
    }
    @thing.attributes = attributes
    assert_equal Time.local(2004, 12, 12, 0, 12, 2), @thing.attributes['written_on']
  end
  
  def test_multiparameter_attributes_on_time_will_ignore_hour_if_blank
    attributes = {
      "written_on(1i)" => "", "written_on(2i)" => "", "written_on(3i)" => "",
      "written_on(4i)" => "", "written_on(5i)" => "12", "written_on(6i)" => "02"
    }
    @thing.attributes = attributes
    assert_nil @thing.attributes['written_on']
  end

  def test_multiparameter_attributes_on_time_will_ignore_date_if_empty
    attributes = {
      "written_on(1i)" => "", "written_on(2i)" => "", "written_on(3i)" => "",
      "written_on(4i)" => "16", "written_on(5i)" => "24"
    }

    @thing.attributes = attributes
    assert_nil @thing.attributes['written_on']
  end
  
  def test_multiparameter_attributes_on_time_with_seconds_will_ignore_date_if_empty
    attributes = {
      "written_on(1i)" => "", "written_on(2i)" => "", "written_on(3i)" => "",
      "written_on(4i)" => "16", "written_on(5i)" => "12", "written_on(6i)" => "02"
    }

    @thing.attributes = attributes
    assert_nil @thing.attributes['written_on']
  end

  def test_multiparameter_attributes_on_time_with_empty_seconds
    attributes = {
      "written_on(1i)" => "2004", "written_on(2i)" => "6", "written_on(3i)" => "24",
      "written_on(4i)" => "16", "written_on(5i)" => "24", "written_on(6i)" => ""
    }

    @thing.attributes = attributes
    assert_equal Time.local(2004, 6, 24, 16, 24, 0), @thing.attributes['written_on']
  end

end
