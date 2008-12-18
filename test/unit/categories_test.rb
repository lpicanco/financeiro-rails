require File.dirname(__FILE__) + '/../test_helper'

class CategoriesTest < Test::Unit::TestCase
  fixtures :category

	NEW_CATEGORIES = {}	# e.g. {:name => 'Test Categories', :description => 'Dummy'}
	REQ_ATTR_NAMES 			 = %w( ) # name of fields that must be present, e.g. %(name description)
	DUPLICATE_ATTR_NAMES = %w( ) # name of fields that cannot be a duplicate, e.g. %(name description)

  def setup
    # Retrieve fixtures via their name
    # @first = category(:first)
  end

  def test_raw_validation
    categories = Categories.new
    if REQ_ATTR_NAMES.blank?
      assert categories.valid?, "Categories should be valid without initialisation parameters"
    else
      # If Categories has validation, then use the following:
      assert !categories.valid?, "Categories should not be valid without initialisation parameters"
      REQ_ATTR_NAMES.each {|attr_name| assert categories.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"}
    end
  end

	def test_new
    categories = Categories.new(NEW_CATEGORIES)
    assert categories.valid?, "Categories should be valid"
   	NEW_CATEGORIES.each do |attr_name|
      assert_equal NEW_CATEGORIES[attr_name], categories.attributes[attr_name], "Categories.@#{attr_name.to_s} incorrect"
    end
 	end

	def test_validates_presence_of
   	REQ_ATTR_NAMES.each do |attr_name|
			tmp_categories = NEW_CATEGORIES.clone
			tmp_categories.delete attr_name.to_sym
			categories = Categories.new(tmp_categories)
			assert !categories.valid?, "Categories should be invalid, as @#{attr_name} is invalid"
    	assert categories.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"
    end
 	end

	def test_duplicate
    current_categories = Categories.find_first
   	DUPLICATE_ATTR_NAMES.each do |attr_name|
   		categories = Categories.new(NEW_CATEGORIES.merge(attr_name.to_sym => current_categories[attr_name]))
			assert !categories.valid?, "Categories should be invalid, as @#{attr_name} is a duplicate"
    	assert categories.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"
		end
	end
end

