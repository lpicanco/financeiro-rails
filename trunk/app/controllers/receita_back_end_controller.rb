class ReceitaBackEndController < ApplicationController
  wsdl_service_name 'ReceitaBackEnd'
  web_service_scaffold :invoke

  def list(login, password, start_date, end_date)    
    check_login(login, password)
    
    receitas = Transactions.find(:all, :order => 'data',
      :conditions => ["user_id = ? AND tipo = ? AND (data BETWEEN ? AND ?)", 
      @user.id, 'r', start_date, end_date]).map {|desp| map_receita(desp)}
  end

  def create(login, password, description, categories, account_id, value, date)
    check_login(login, password)
    
    @receita = Transactions.new
    @receita.tipo = 'r'
    @receita.descricao = description
    @receita.tag_with(categories, @user)
    @receita.account_id = account_id
    @receita.user_id = @user.id
    @receita.valor = value
    @receita.data = date
    
    @receita.save
  end  

  def update(login, password, id, description, categories, account_id, value, date)
    check_login(login, password)
    
    @receita = Transactions.find(id)
    @receita.tipo = 'r'
    @receita.descricao = description
    @receita.tag_with(categories, @user)
    @receita.account_id = account_id
    @receita.user_id = @user.id
    @receita.valor = value
    @receita.data = date
    
    @receita.save
  end

  def destroy(login, password, id)
    check_login(login, password)
    
    Transactions.destroy(id).frozen?
  end
  
  private  
  def check_login(login, password)
    @user = User.authenticate(login, password)    
    raise "Login ou senha inválida" if @user.nil?
  end
  
  def map_receita(receita)
    ReceitaStruct.new :id => receita.id, 
      :description => receita.descricao,
      :categories => receita.tags.join(" "),
      :account_id => receita.account_id,
      :value => receita.valor,
      :date => receita.data
  end
end
