require File.dirname(__FILE__) + '/../test_helper'

class EntryTest < Test::Unit::TestCase
  fixtures :entries

	NEW_ENTRY = {}	# e.g. {:name => 'Test Entry', :description => 'Dummy'}
	REQ_ATTR_NAMES 			 = %w( ) # name of fields that must be present, e.g. %(name description)
	DUPLICATE_ATTR_NAMES = %w( ) # name of fields that cannot be a duplicate, e.g. %(name description)

  def setup
    # Retrieve fixtures via their name
    # @first = entries(:first)
  end

  def test_raw_validation
    entry = Entry.new
    if REQ_ATTR_NAMES.blank?
      assert entry.valid?, "Entry should be valid without initialisation parameters"
    else
      # If Entry has validation, then use the following:
      assert !entry.valid?, "Entry should not be valid without initialisation parameters"
      REQ_ATTR_NAMES.each {|attr_name| assert entry.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"}
    end
  end

	def test_new
    entry = Entry.new(NEW_ENTRY)
    assert entry.valid?, "Entry should be valid"
   	NEW_ENTRY.each do |attr_name|
      assert_equal NEW_ENTRY[attr_name], entry.attributes[attr_name], "Entry.@#{attr_name.to_s} incorrect"
    end
 	end

	def test_validates_presence_of
   	REQ_ATTR_NAMES.each do |attr_name|
			tmp_entry = NEW_ENTRY.clone
			tmp_entry.delete attr_name.to_sym
			entry = Entry.new(tmp_entry)
			assert !entry.valid?, "Entry should be invalid, as @#{attr_name} is invalid"
    	assert entry.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"
    end
 	end

	def test_duplicate
    current_entry = Entry.find_first
   	DUPLICATE_ATTR_NAMES.each do |attr_name|
   		entry = Entry.new(NEW_ENTRY.merge(attr_name.to_sym => current_entry[attr_name]))
			assert !entry.valid?, "Entry should be invalid, as @#{attr_name} is a duplicate"
    	assert entry.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"
		end
	end
end

