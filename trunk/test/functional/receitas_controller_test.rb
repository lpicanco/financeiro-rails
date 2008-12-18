require File.dirname(__FILE__) + '/../test_helper'
require '/receitas_controller'

# Re-raise errors caught by the controller.
class ReceitasController; def rescue_action(e) raise e end; end

class ReceitasControllerTest < Test::Unit::TestCase
  fixtures :receitas

  def setup
    @controller = ReceitasController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # A better generator might actually keep updated tests in here, until then its probably better to have nothing than something broken

end
