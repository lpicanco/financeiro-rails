class AccountsController < ApplicationController
  ajax_scaffold :account
  
  @@scaffold_columns = [          
          AjaxScaffold::ScaffoldColumn.new(Account, { :name => "nome",
            :eval => "row.name", :sort => 'name' }),
          AjaxScaffold::ScaffoldColumn.new(Account, { :name => "descricao",
            :eval => "row.description", :sort => 'description' })
  ]  
  
  def conditions_for_accounts_collection
    [ 'user_id = ?',  get_user_id]
  end
    
  def do_create#{suffix}
    @account = Account.new(params[:account])
    @account.user_id = get_user_id
    @successful = @account.save
  end  
end
