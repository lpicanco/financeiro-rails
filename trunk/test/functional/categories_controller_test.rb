require File.dirname(__FILE__) + '/../test_helper'
require 'categories_controller'

# Re-raise errors caught by the controller.
class CategoriesController; def rescue_action(e) raise e end; end

class CategoriesControllerTest < Test::Unit::TestCase
  fixtures :categories

	NEW_CATEGORY = {}	# e.g. {:name => 'Test Category', :description => 'Dummy'}
	REDIRECT_TO_MAIN = {:action => 'list'} # put hash or string redirection that you normally expect

	def setup
		@controller = CategoriesController.new
		@request    = ActionController::TestRequest.new
		@response   = ActionController::TestResponse.new
		# Retrieve fixtures via their name
		# @first = categories(:first)
		@first = Category.find_first
	end

  def test_component
    get :component
    assert_response :success
    assert_template 'categories/component'
    categories = check_attrs(%w(categories))
    assert_equal Category.find(:all).length, categories.length, "Incorrect number of categories shown"
  end

  def test_component_update
    get :component_update
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_component_update_xhr
    xhr :get, :component_update
    assert_response :success
    assert_template 'categories/component'
    categories = check_attrs(%w(categories))
    assert_equal Category.find(:all).length, categories.length, "Incorrect number of categories shown"
  end

  def test_create
  	category_count = Category.find(:all).length
    post :create, {:category => NEW_CATEGORY}
    category, successful = check_attrs(%w(category successful))
    assert successful, "Should be successful"
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
    assert_equal category_count + 1, Category.find(:all).length, "Expected an additional Category"
  end

  def test_create_xhr
  	category_count = Category.find(:all).length
    xhr :post, :create, {:category => NEW_CATEGORY}
    category, successful = check_attrs(%w(category successful))
    assert successful, "Should be successful"
    assert_response :success
    assert_template 'create.rjs'
    assert_equal category_count + 1, Category.find(:all).length, "Expected an additional Category"
  end

  def test_update
  	category_count = Category.find(:all).length
    post :update, {:id => @first.id, :category => @first.attributes.merge(NEW_CATEGORY)}
    category, successful = check_attrs(%w(category successful))
    assert successful, "Should be successful"
    category.reload
   	NEW_CATEGORY.each do |attr_name|
      assert_equal NEW_CATEGORY[attr_name], category.attributes[attr_name], "@category.#{attr_name.to_s} incorrect"
    end
    assert_equal category_count, Category.find(:all).length, "Number of Categorys should be the same"
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_update_xhr
  	category_count = Category.find(:all).length
    xhr :post, :update, {:id => @first.id, :category => @first.attributes.merge(NEW_CATEGORY)}
    category, successful = check_attrs(%w(category successful))
    assert successful, "Should be successful"
    category.reload
   	NEW_CATEGORY.each do |attr_name|
      assert_equal NEW_CATEGORY[attr_name], category.attributes[attr_name], "@category.#{attr_name.to_s} incorrect"
    end
    assert_equal category_count, Category.find(:all).length, "Number of Categorys should be the same"
    assert_response :success
    assert_template 'update.rjs'
  end

  def test_destroy
  	category_count = Category.find(:all).length
    post :destroy, {:id => @first.id}
    assert_response :redirect
    assert_equal category_count - 1, Category.find(:all).length, "Number of Categorys should be one less"
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_destroy_xhr
  	category_count = Category.find(:all).length
    xhr :post, :destroy, {:id => @first.id}
    assert_response :success
    assert_equal category_count - 1, Category.find(:all).length, "Number of Categorys should be one less"
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
