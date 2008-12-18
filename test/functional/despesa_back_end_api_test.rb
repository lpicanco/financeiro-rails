require File.dirname(__FILE__) + '/../test_helper'
require 'despesa_back_end_controller'

class DespesaBackEndController; def rescue_action(e) raise e end; end

class DespesaBackEndControllerApiTest < Test::Unit::TestCase
  def setup
    @controller = DespesaBackEndController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_list
    result = invoke :list
    assert_equal nil, result
  end

  def test_create
    result = invoke :create
    assert_equal nil, result
  end

  def test_update
    result = invoke :update
    assert_equal nil, result
  end

  def test_destroy
    result = invoke :destroy
    assert_equal nil, result
  end
end
