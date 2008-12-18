class User < ActiveRecord::Base
  include LoginEngine::AuthenticatedUser
  
  validates_uniqueness_of(:login, :message => "Login já existente")

  def self.anonymous_user
    @user = User.new
    @user.id = 0
    @user
  end

end

