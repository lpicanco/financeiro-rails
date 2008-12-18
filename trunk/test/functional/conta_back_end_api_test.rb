require File.dirname(__FILE__) + '/../test_helper'
require 'conta_back_end_controller'

class ContaBackEndController; def rescue_action(e) raise e end; end

class ContaBackEndControllerApiTest < Test::Unit::TestCase
  def setup
    @controller = ContaBackEndController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end
end
