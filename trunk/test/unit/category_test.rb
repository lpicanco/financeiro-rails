require File.dirname(__FILE__) + '/../test_helper'

class CategoryTest < Test::Unit::TestCase
  fixtures :categories

	NEW_CATEGORY = {}	# e.g. {:name => 'Test Category', :description => 'Dummy'}
	REQ_ATTR_NAMES 			 = %w( ) # name of fields that must be present, e.g. %(name description)
	DUPLICATE_ATTR_NAMES = %w( ) # name of fields that cannot be a duplicate, e.g. %(name description)

  def setup
    # Retrieve fixtures via their name
    # @first = categories(:first)
  end

  def test_raw_validation
    category = Category.new
    if REQ_ATTR_NAMES.blank?
      assert category.valid?, "Category should be valid without initialisation parameters"
    else
      # If Category has validation, then use the following:
      assert !category.valid?, "Category should not be valid without initialisation parameters"
      REQ_ATTR_NAMES.each {|attr_name| assert category.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"}
    end
  end

	def test_new
    category = Category.new(NEW_CATEGORY)
    assert category.valid?, "Category should be valid"
   	NEW_CATEGORY.each do |attr_name|
      assert_equal NEW_CATEGORY[attr_name], category.attributes[attr_name], "Category.@#{attr_name.to_s} incorrect"
    end
 	end

	def test_validates_presence_of
   	REQ_ATTR_NAMES.each do |attr_name|
			tmp_category = NEW_CATEGORY.clone
			tmp_category.delete attr_name.to_sym
			category = Category.new(tmp_category)
			assert !category.valid?, "Category should be invalid, as @#{attr_name} is invalid"
    	assert category.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"
    end
 	end

	def test_duplicate
    current_category = Category.find_first
   	DUPLICATE_ATTR_NAMES.each do |attr_name|
   		category = Category.new(NEW_CATEGORY.merge(attr_name.to_sym => current_category[attr_name]))
			assert !category.valid?, "Category should be invalid, as @#{attr_name} is a duplicate"
    	assert category.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"
		end
	end
end

