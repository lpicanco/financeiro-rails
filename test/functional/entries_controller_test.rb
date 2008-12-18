require File.dirname(__FILE__) + '/../test_helper'
require 'entries_controller'

# Re-raise errors caught by the controller.
class EntriesController; def rescue_action(e) raise e end; end

class EntriesControllerTest < Test::Unit::TestCase
  fixtures :entries

	NEW_ENTRY = {}	# e.g. {:name => 'Test Entry', :description => 'Dummy'}
	REDIRECT_TO_MAIN = {:action => 'list'} # put hash or string redirection that you normally expect

	def setup
		@controller = EntriesController.new
		@request    = ActionController::TestRequest.new
		@response   = ActionController::TestResponse.new
		# Retrieve fixtures via their name
		# @first = entries(:first)
		@first = Entry.find_first
	end

  def test_component
    get :component
    assert_response :success
    assert_template 'entries/component'
    entries = check_attrs(%w(entries))
    assert_equal Entry.find(:all).length, entries.length, "Incorrect number of entries shown"
  end

  def test_component_update
    get :component_update
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_component_update_xhr
    xhr :get, :component_update
    assert_response :success
    assert_template 'entries/component'
    entries = check_attrs(%w(entries))
    assert_equal Entry.find(:all).length, entries.length, "Incorrect number of entries shown"
  end

  def test_create
  	entry_count = Entry.find(:all).length
    post :create, {:entry => NEW_ENTRY}
    entry, successful = check_attrs(%w(entry successful))
    assert successful, "Should be successful"
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
    assert_equal entry_count + 1, Entry.find(:all).length, "Expected an additional Entry"
  end

  def test_create_xhr
  	entry_count = Entry.find(:all).length
    xhr :post, :create, {:entry => NEW_ENTRY}
    entry, successful = check_attrs(%w(entry successful))
    assert successful, "Should be successful"
    assert_response :success
    assert_template 'create.rjs'
    assert_equal entry_count + 1, Entry.find(:all).length, "Expected an additional Entry"
  end

  def test_update
  	entry_count = Entry.find(:all).length
    post :update, {:id => @first.id, :entry => @first.attributes.merge(NEW_ENTRY)}
    entry, successful = check_attrs(%w(entry successful))
    assert successful, "Should be successful"
    entry.reload
   	NEW_ENTRY.each do |attr_name|
      assert_equal NEW_ENTRY[attr_name], entry.attributes[attr_name], "@entry.#{attr_name.to_s} incorrect"
    end
    assert_equal entry_count, Entry.find(:all).length, "Number of Entrys should be the same"
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_update_xhr
  	entry_count = Entry.find(:all).length
    xhr :post, :update, {:id => @first.id, :entry => @first.attributes.merge(NEW_ENTRY)}
    entry, successful = check_attrs(%w(entry successful))
    assert successful, "Should be successful"
    entry.reload
   	NEW_ENTRY.each do |attr_name|
      assert_equal NEW_ENTRY[attr_name], entry.attributes[attr_name], "@entry.#{attr_name.to_s} incorrect"
    end
    assert_equal entry_count, Entry.find(:all).length, "Number of Entrys should be the same"
    assert_response :success
    assert_template 'update.rjs'
  end

  def test_destroy
  	entry_count = Entry.find(:all).length
    post :destroy, {:id => @first.id}
    assert_response :redirect
    assert_equal entry_count - 1, Entry.find(:all).length, "Number of Entrys should be one less"
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_destroy_xhr
  	entry_count = Entry.find(:all).length
    xhr :post, :destroy, {:id => @first.id}
    assert_response :success
    assert_equal entry_count - 1, Entry.find(:all).length, "Number of Entrys should be one less"
    assert_template 'destroy.rjs'
  end

protected
	# Could be put in a Helper library and included at top of test class
  def check_attrs(attr_list)
    attrs = []
    attr_list.each do |attr_sym|
      attr = assigns(attr_sym.to_sym)
      assert_not_nil attr,       "Attribute @#{attr_sym} should not be nil"
      assert !attr.new_record?,  "Should have saved the @#{attr_sym} obj" if attr.class == ActiveRecord
      attrs << attr
    end
    attrs.length > 1 ? attrs : attrs[0]
  end
end
