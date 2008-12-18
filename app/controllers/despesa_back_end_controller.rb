class DespesaBackEndController < ApplicationController
  wsdl_service_name 'DespesaBackEnd'
  web_service_scaffold :invoke

  def list(login, password, start_date, end_date)    
    check_login(login, password)
    
    despesas = Transactions.find(:all, :order => 'data',
      :conditions => ["user_id = ? AND tipo = ? AND (data BETWEEN ? AND ?)", 
      @user.id, 'd', start_date, end_date]).map {|desp| map_despesa(desp)}
  end

  def create(login, password, description, categories, account_id, value, date)
    check_login(login, password)
    
    @despesa = Transactions.new
    @despesa.tipo = 'd'
    @despesa.descricao = description
    @despesa.tag_with(categories, @user)
    @despesa.account_id = account_id
    @despesa.user_id = @user.id
    @despesa.valor = value
    @despesa.data = date
    
    @despesa.save
  end
  
  def update(login, password, id, description, categories, account_id, value, date)
    check_login(login, password)
    
    @despesa = Transactions.find(id)
    @despesa.tipo = 'd'
    @despesa.descricao = description
    @despesa.tag_with(categories, @user)
    @despesa.account_id = account_id
    @despesa.user_id = @user.id
    @despesa.valor = value
    @despesa.data = date
    
    @despesa.save
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
  
  def map_despesa(despesa)
    DespesaStruct.new :id => despesa.id, 
      :description => despesa.descricao,
      :categories => despesa.tags.join(" "),
      :account_id => despesa.account_id,
      :value => despesa.valor,
      :date => despesa.data
  end
end
