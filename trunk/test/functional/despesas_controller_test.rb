require File.dirname(__FILE__) + '/../test_helper'
require 'despesas_controller'

# Re-raise errors caught by the controller.
class DespesasController; def rescue_action(e) raise e end; end

class DespesasControllerTest < Test::Unit::TestCase
  def setup
    @controller = DespesasController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
