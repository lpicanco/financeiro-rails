require File.dirname(__FILE__) + '/../test_helper'
require 'ferramentas_controller'

# Re-raise errors caught by the controller.
class FerramentasController; def rescue_action(e) raise e end; end

class FerramentasControllerTest < Test::Unit::TestCase
  def setup
    @controller = FerramentasController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
