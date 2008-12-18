require File.dirname(__FILE__) + '/../test_helper'
require 'net_vibes_extension_controller'

# Re-raise errors caught by the controller.
class NetVibesExtensionController; def rescue_action(e) raise e end; end

class NetVibesExtensionControllerTest < Test::Unit::TestCase
  def setup
    @controller = NetVibesExtensionController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
