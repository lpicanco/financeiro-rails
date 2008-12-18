class DespesasController < ApplicationController
  
  ajax_scaffold :transactions, :totals => ['valor']
  
  @@scaffold_columns = [          
          AjaxScaffold::ScaffoldColumn.new(Despesa, { :name => "descricao",
            :eval => "row.descricao", :sortable => false}), # :sort => 'descricao' }),
          AjaxScaffold::ScaffoldColumn.new(Despesa, { :name => "categorias",
            :eval => "row.tag_list", :sortable => false}), # :sort => 'tag_list' }),
          AjaxScaffold::ScaffoldColumn.new(Despesa, { :name => "conta",
            :eval => "row.account.name ", :sortable => false}), # :sort => 'account.name' }),
          AjaxScaffold::ScaffoldColumn.new(Despesa, { :name => "valor", 
            :eval => "row.formated_value.formated", :sortable => false}), # :sort => 'formated_value' }),
          AjaxScaffold::ScaffoldColumn.new(Despesa, { :name => "data", 
            :eval => "row.data.strftime('%d/%m/%Y')", :sortable => false})# :sort => 'data'}) 
  ]
   
  def get_despesas
    @despesa = Transactions.new
    @despesa.data = Date.today
    
    if (params[:despesa].nil?)
      dt_ini = Date.civil(@despesa.data.year, @despesa.data.month, 1)
      dt_fim = Date.civil(@despesa.data.year, @despesa.data.month + 1, 1)
      dt_fim -= 1
    else
      @despesa = Despesa.new
                  
      dt_ini = Date.civil(
        params[:despesa]["data(1i)"].to_i,
        params[:despesa]["data(2i)"].to_i,
        1) 
      
      dt_fim = Date.civil(
        params[:despesa]["data(1i)"].to_i,
        params[:despesa]["data(2i)"].to_i + 1,
        1)
      dt_fim -= 1
      
      @despesa.data = dt_ini;
    end
    
    select = "SELECT d.* FROM transactions d WHERE "
    
    where = ['d.user_id = ? AND (d.data BETWEEN ? AND ?) AND d.tipo = ? ',  get_user_id, dt_ini, dt_fim, 'd']
    val_conditions = 4
    
    unless (params[:despesa].nil?)
      unless (params[:despesa][:account_id].nil?)
        if (params[:despesa][:account_id].to_i > 0)
          val_conditions += 1
          
          where[0] << ' AND account_id = ?'
          where[val_conditions] = params[:despesa][:account_id].to_i
          @despesa.account_id = params[:despesa][:account_id].to_i
        end
      end      
    end
    
    unless params[:categoria].nil?
      unless params[:categoria] == ""        
        @categoria = params[:categoria]
        select = "SELECT d.* FROM transactions d, taggings tg, tags t WHERE "  
        where[0] << ' AND d.id = tg.taggable_id AND tg.tag_id = t.id AND tg.taggable_type = "Transactions" AND ' +
            't.name like ? GROUP BY tg.taggable_id'
        val_conditions += 1
        where[val_conditions] = "%" << params[:categoria] << "%"
      end
    end
        
    where[0] = select << " " << where[0]
    
    @despesas = Transactions.find_by_sql(where)
  end  
  
  def count_transactions_collection(model, options)
    get_despesas.size
  end
    
  def page_and_sort_transactions_collection_with_method(model, options, paginator)
    collection = get_despesas
    order_parts = options[:order].split(' ')
    sort_collection_by_method(collection, order_parts[0], order_parts[1])#.slice(paginator.current.offset,options[:per_page])   
  end 
  
  def page_and_sort_transactions_collection(model, options, paginator)
    page_and_sort_transactions_collection_with_method(model, options, paginator)
  end
  
  def do_new#{suffix}
    @despesa = Transactions.new
    @successful = true
  end
  
  def do_edit#{suffix}
    @despesa = Transactions.find(params[:id])
    @successful = !@despesa.nil?
  end  
  
  def do_create#{suffix}    
    params[:despesa][:valor] = params[:despesa][:valor].gsub(/\,/, ".")

    @transactions = Transactions.new(params[:despesa])
    @transactions.user_id = get_user_id
    @transactions.tipo = 'd'
    @transactions.tag_with(params[:tag_list], current_user)
    @successful = @transactions.save
  end
  
  def do_update#{suffix}
    params[:despesa][:valor] = params[:despesa][:valor].gsub(/\,/, ".")

    @transactions = Transactions.find(params[:id])
    @successful = @transactions.update_attributes(params[:despesa])
    if @successful
      @transactions.tag_with(params[:tag_list], current_user)
      @successful = @transactions.save
    end
  end   
end
