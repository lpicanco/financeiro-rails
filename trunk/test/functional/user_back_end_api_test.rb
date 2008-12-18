require File.dirname(__FILE__) + '/../test_helper'
require 'user_back_end_controller'

class UserBackEndController; def rescue_action(e) raise e end; end

class UserBackEndControllerApiTest < Test::Unit::TestCase
  def setup
    @controller = UserBackEndController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end
end
