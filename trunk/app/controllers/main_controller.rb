class MainController < ApplicationController
  
  def index
    #convert
    
    saldos
    categorias
  end
  
  def saldos
    @accounts = Account.find(:all, :conditions => ["user_id = ? ", get_user_id])
  end
  
  def categorias
    date = Date.today
    
    start_date = Date.civil(date.year, date.month, 1)
    end_date = Date.civil(date.year, date.month + 1, 1)
    end_date -= 1
    
    @cat_despesas = Transactions.get_by_tag(get_user_id, start_date, end_date, 'd')
    @cat_receitas = Transactions.get_by_tag(get_user_id, start_date, end_date, 'r')
  end
  
  def convert

    @despesas = Despesa.find(:all)
    
    @despesas.each do |d|
      @t = Transactions.new
      @t.user_id = d.user_id
      @t.account_id = d.account_id
      @t.tipo = 'd'
      @t.descricao = d.descricao
      @t.valor = d.valor
      @t.data = d.data
      
      user = d.user
      
      if (user.nil?)
        user = User.new
        user.id = 0
      end      
      @t.tag_with(d.tags.join(" "), user)
      @t.save
    end
    
    @receitas = Receita.find(:all)
    
    @receitas.each do |d|
      @t = Transactions.new
      @t.user_id = d.user_id
      @t.account_id = d.account_id
      @t.tipo = 'r'
      @t.descricao = d.descricao
      @t.valor = d.valor
      @t.data = d.data

      user = d.user
      
      if (user.nil?)
        user = User.new
        user.id = 0
      end      
      @t.tag_with(d.tags.join(" "), user)
      @t.save
    end
    
  end
end
