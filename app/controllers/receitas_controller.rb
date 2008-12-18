class ReceitasController < ApplicationController
  ajax_scaffold :transactions, :totals => ['valor']
  
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
  
  def get_receitas
    @receita = Transactions.new
    @receita.data = Date.today
    
    if (params[:receita].nil?)
      dt_ini = Date.civil(@receita.data.year, @receita.data.month, 1)
      dt_fim = Date.civil(@receita.data.year, @receita.data.month + 1, 1)
      dt_fim -= 1
    else
      @receita = Receita.new
                  
      dt_ini = Date.civil(
        params[:receita]["data(1i)"].to_i,
        params[:receita]["data(2i)"].to_i,
        1) 
      
      dt_fim = Date.civil(
        params[:receita]["data(1i)"].to_i,
        params[:receita]["data(2i)"].to_i + 1,
        1)
      dt_fim -= 1
      
      @receita.data = dt_ini;
    end
    
    select = "SELECT d.* FROM transactions d WHERE "
    
    where = ['d.user_id = ? AND (d.data BETWEEN ? AND ?) AND d.tipo = ? ',  get_user_id, dt_ini, dt_fim, 'r']
    val_conditions = 4
    
    unless (params[:receita].nil?)
      unless (params[:receita][:account_id].nil?)
        if (params[:receita][:account_id].to_i > 0)
          val_conditions += 1
          
          where[0] << ' AND account_id = ?'
          where[val_conditions] = params[:receita][:account_id].to_i
          @receita.account_id = params[:receita][:account_id].to_i
        end
      end      
    end
    
    unless params[:categoria].nil?
      unless params[:categoria] == ""
        @categoria = params[:categoria]
        select = "SELECT d.* FROM receitas d, taggings tg, tags t WHERE "  
        where[0] << ' AND d.id = tg.taggable_id AND tg.tag_id = t.id AND tg.taggable_type = "Receita" AND ' +
            't.name like ? GROUP BY tg.taggable_id'
        val_conditions += 1
        where[val_conditions] = "%" << params[:categoria] << "%"
      end
    end
        
    where[0] = select << " " << where[0]
    
    @receitas = Transactions.find_by_sql(where)
  end  
  
  def count_transactions_collection(model, options)
    get_receitas.size
  end
    
  def page_and_sort_transactions_collection_with_method(model, options, paginator)
    collection = get_receitas
    order_parts = options[:order].split(' ')
    sort_collection_by_method(collection, order_parts[0], order_parts[1])#.slice(paginator.current.offset,options[:per_page])   
  end 
  
  def page_and_sort_transactions_collection(model, options, paginator)
    page_and_sort_transactions_collection_with_method(model, options, paginator)
  end   
    
  def do_new#{suffix}
    @receita = Transactions.new
    @successful = true
  end
  
  def do_edit#{suffix}
    @receita = Transactions.find(params[:id])
    @successful = !@receita.nil?
  end 

  def do_create#{suffix}
    params[:receita][:valor] = params[:receita][:valor].gsub(/\,/, ".")

    @transactions = Transactions.new(params[:receita])
    @transactions.user_id = get_user_id
    @transactions.tipo = 'r'
    @transactions.tag_with(params[:tag_list], current_user)
    @successful = @transactions.save
  end
  
  def do_update#{suffix}
    params[:receita][:valor] = params[:receita][:valor].gsub(/\,/, ".")

    @transactions = Transactions.find(params[:id])
    @successful = @transactions.update_attributes(params[:receita])
    if @successful
      @transactions.tag_with(params[:tag_list], current_user)
      @successful = @transactions.save
    end
  end      
end
