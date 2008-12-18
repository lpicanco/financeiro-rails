require File.dirname(__FILE__) + '/../test_helper'
require 'receita_back_end_controller'

class ReceitaBackEndController; def rescue_action(e) raise e end; end

class ReceitaBackEndControllerApiTest < Test::Unit::TestCase
  def setup
    @controller = ReceitaBackEndController.new
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
