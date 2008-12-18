require File.dirname(__FILE__) + '/../test_helper'
require 'consolidado_controller'

# Re-raise errors caught by the controller.
class ConsolidadoController; def rescue_action(e) raise e end; end

class ConsolidadoControllerTest < Test::Unit::TestCase
  def setup
    @controller = ConsolidadoController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
