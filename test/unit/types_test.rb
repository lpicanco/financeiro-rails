require File.dirname(__FILE__) + '/../test_helper'

class TypesTest < Test::Unit::TestCase
  fixtures :types

	NEW_TYPES = {}	# e.g. {:name => 'Test Types', :description => 'Dummy'}
	REQ_ATTR_NAMES 			 = %w( ) # name of fields that must be present, e.g. %(name description)
	DUPLICATE_ATTR_NAMES = %w( ) # name of fields that cannot be a duplicate, e.g. %(name description)

  def setup
    # Retrieve fixtures via their name
    # @first = types(:first)
  end

  def test_raw_validation
    types = Types.new
    if REQ_ATTR_NAMES.blank?
      assert types.valid?, "Types should be valid without initialisation parameters"
    else
      # If Types has validation, then use the following:
      assert !types.valid?, "Types should not be valid without initialisation parameters"
      REQ_ATTR_NAMES.each {|attr_name| assert types.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"}
    end
  end

	def test_new
    types = Types.new(NEW_TYPES)
    assert types.valid?, "Types should be valid"
   	NEW_TYPES.each do |attr_name|
      assert_equal NEW_TYPES[attr_name], types.attributes[attr_name], "Types.@#{attr_name.to_s} incorrect"
    end
 	end

	def test_validates_presence_of
   	REQ_ATTR_NAMES.each do |attr_name|
			tmp_types = NEW_TYPES.clone
			tmp_types.delete attr_name.to_sym
			types = Types.new(tmp_types)
			assert !types.valid?, "Types should be invalid, as @#{attr_name} is invalid"
    	assert types.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"
    end
 	end

	def test_duplicate
    current_types = Types.find_first
   	DUPLICATE_ATTR_NAMES.each do |attr_name|
   		types = Types.new(NEW_TYPES.merge(attr_name.to_sym => current_types[attr_name]))
			assert !types.valid?, "Types should be invalid, as @#{attr_name} is a duplicate"
    	assert types.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"
		end
	end
end

