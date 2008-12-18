class ConsolidadoController < ApplicationController
  ajax_scaffold :transactions, :totals => ['valor'], :except => ['create', 'delete', 'edit']
  
  @@scaffold_columns = [          
          AjaxScaffold::ScaffoldColumn.new(Receita, { :name => "descricao",
            :eval => "row.descricao",:sortable => false}), # :sort => 'descricao' }),
          AjaxScaffold::ScaffoldColumn.new(Receita, { :name => "categorias",
            :eval => "row.tag_list",:sortable => false}), # :sort => 'tags.tag_list' }),
          AjaxScaffold::ScaffoldColumn.new(Receita, { :name => "conta",
            :eval => "row.account.name ",:sortable => false}), # :sort => 'account.name' }),
          AjaxScaffold::ScaffoldColumn.new(Receita, { :name => "valor", 
            :eval => "row.formated_value.formated",:sortable => false}), # :sort => 'formated_value ' }),
          AjaxScaffold::ScaffoldColumn.new(Receita, { :name => "data", 
            :eval => "row.data.strftime('%d/%m/%Y')",:sortable => false}) # :sort => 'data' })
  ]  

  def get_consolidado
    @consolidado = Transactions.new
    @consolidado.data = Date.today
    
    if (params[:consolidado].nil?)
      dt_ini = Date.civil(@consolidado.data.year, @consolidado.data.month, 1)
      dt_fim = Date.civil(@consolidado.data.year, @consolidado.data.month + 1, 1)
      dt_fim -= 1
    else
      @consolidado = Despesa.new
                  
      dt_ini = Date.civil(
        params[:consolidado]["data(1i)"].to_i,
        params[:consolidado]["data(2i)"].to_i,
        1) 
      
      dt_fim = Date.civil(
        params[:consolidado]["data(1i)"].to_i,
        params[:consolidado]["data(2i)"].to_i + 1,
        1)
      dt_fim -= 1
      
      @consolidado.data = dt_ini;
    end
    
    select = "SELECT d.* FROM transactions d WHERE "
    
    where = ['d.user_id = ? AND (d.data BETWEEN ? AND ?) ',  get_user_id, dt_ini, dt_fim]
    val_conditions = 3
    
    unless (params[:consolidado].nil?)
      unless (params[:consolidado][:account_id].nil?)
        if (params[:consolidado][:account_id].to_i > 0)
          val_conditions += 1
          
          where[0] << ' AND account_id = ?'
          where[val_conditions] = params[:consolidado][:account_id].to_i
          @consolidado.account_id = params[:consolidado][:account_id].to_i
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
    
    @consolidados = Transactions.find_by_sql(where)
  end
  
  def count_transactions_collection(model, options)
    get_consolidado.size
  end
    
  def page_and_sort_transactions_collection_with_method(model, options, paginator)
    collection = get_consolidado
    order_parts = options[:order].split(' ')
    sort_collection_by_method(collection, order_parts[0], order_parts[1])#.slice(paginator.current.offset,options[:per_page])   
  end 
  
  def page_and_sort_transactions_collection(model, options, paginator)
    page_and_sort_transactions_collection_with_method(model, options, paginator)
  end 
  
  def default_sort
     "transactions.data" 
  end  
  
end
