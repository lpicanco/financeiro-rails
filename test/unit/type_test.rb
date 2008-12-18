require File.dirname(__FILE__) + '/../test_helper'

class TypeTest < Test::Unit::TestCase
  fixtures :types

	NEW_TYPE = {}	# e.g. {:name => 'Test Type', :description => 'Dummy'}
	REQ_ATTR_NAMES 			 = %w( ) # name of fields that must be present, e.g. %(name description)
	DUPLICATE_ATTR_NAMES = %w( ) # name of fields that cannot be a duplicate, e.g. %(name description)

  def setup
    # Retrieve fixtures via their name
    # @first = types(:first)
  end

  def test_raw_validation
    type = Type.new
    if REQ_ATTR_NAMES.blank?
      assert type.valid?, "Type should be valid without initialisation parameters"
    else
      # If Type has validation, then use the following:
      assert !type.valid?, "Type should not be valid without initialisation parameters"
      REQ_ATTR_NAMES.each {|attr_name| assert type.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"}
    end
  end

	def test_new
    type = Type.new(NEW_TYPE)
    assert type.valid?, "Type should be valid"
   	NEW_TYPE.each do |attr_name|
      assert_equal NEW_TYPE[attr_name], type.attributes[attr_name], "Type.@#{attr_name.to_s} incorrect"
    end
 	end

	def test_validates_presence_of
   	REQ_ATTR_NAMES.each do |attr_name|
			tmp_type = NEW_TYPE.clone
			tmp_type.delete attr_name.to_sym
			type = Type.new(tmp_type)
			assert !type.valid?, "Type should be invalid, as @#{attr_name} is invalid"
    	assert type.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"
    end
 	end

	def test_duplicate
    current_type = Type.find_first
   	DUPLICATE_ATTR_NAMES.each do |attr_name|
   		type = Type.new(NEW_TYPE.merge(attr_name.to_sym => current_type[attr_name]))
			assert !type.valid?, "Type should be invalid, as @#{attr_name} is a duplicate"
    	assert type.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"
		end
	end
end

