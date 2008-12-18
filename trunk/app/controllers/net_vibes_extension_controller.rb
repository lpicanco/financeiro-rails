class NetVibesExtensionController < ApplicationController
  def index
    @login = cookies[:login]
    @password = cookies[:password]
  end
  
  def list
    user_id = 0
    login = params[:login]
    password = params[:password]
    
    unless login.nil? || password.nil?    
      @user = User.authenticate(login, password)
    end
    
    user_id = @user.id unless @user.nil?
    
    @transactions = Transactions.find(:all, 
      :conditions => ["user_id = ? AND (data BETWEEN ? AND ?)", user_id, start_date, end_date], :order => 'data')
    
    render :partial => 'list'
  end
  
  private
  def start_date
    date = Date.today
    start_date = Date.civil(date.year, date.month, 1)
  end
  
  def end_date
    date = Date.today
    end_date = Date.civil(date.year, date.month + 1, 1)
    end_date -= 1
  end
end
