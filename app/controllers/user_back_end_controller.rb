class UserBackEndController < ApplicationController
  wsdl_service_name 'UserBackEnd'  
  web_service_scaffold :invoke

  def authenticate(login, password)    
    check_login(login, password)
    map_user(@user, password)
  end
  
  private  
  def check_login(login, password)
    @user = User.authenticate(login, password)    
    raise "Login ou senha invalida" if @user.nil?
  end
  
  def map_user(user, password)
    UserStruct.new :id => user.id, 
      :login => user.login,
      :password => password,
      :first_name => user.firstname,
      :last_name => user.lastname
  end    
  
end
