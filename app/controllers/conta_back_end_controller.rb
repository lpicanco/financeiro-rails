class ContaBackEndController < ApplicationController
  wsdl_service_name 'ContaBackEnd'  
  web_service_scaffold :invoke

  def list(login, password)    
    check_login(login, password)
    
    contas = Account.find(:all, :order => 'name',
      :conditions => ["user_id = ?", 
      @user.id]).map {|cat| map_conta(cat)}
  end
  
  def create(login, password, name, description)
    check_login(login, password)
    
    @conta = Account.new
    @conta.name = name
    @conta.user_id = @user.id
    @conta.description = description
    @conta.save
  end
  
  def update(login, password, id, name, description)
    check_login(login, password)
    
    @conta = Account.find(id)
    @conta.name = name
    @conta.description = description
    @conta.save
  end

  def destroy(login, password, id)
    check_login(login, password)
    
    Account.destroy(id).frozen?
  end    
  
  private  
  def check_login(login, password)
    @user = User.authenticate(login, password)    
    raise "Login ou senha inválida" if @user.nil?
  end
  
  def map_conta(conta)
    ContaStruct.new :id => conta.id, 
      :name => conta.name,
      :description => conta.description
  end  
end
