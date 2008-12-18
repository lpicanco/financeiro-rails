class ReportsController < ApplicationController

  def index
  end
  
  def show_graphics
    generate_graph("despesa.png", "d")
    generate_graph("receita.png", "r")
  end
  
  def generate_graph(file_name, tipo)
    g = Gruff::Line.new(640)
    g.title = "Financeiro - " << start_date.strftime('%m/%Y')
    
    @list_dates = Transactions.find_by_sql(
      ["SELECT d.data FROM transactions d WHERE d.user_id = ? AND " <<
       "(d.data BETWEEN ? AND ?) AND d.tipo = ? GROUP BY d.data ORDER BY d.data", 
      get_user_id, start_date, end_date, tipo])
    
    @depesas = Transactions.find_by_sql(
      ["SELECT SUM(d.valor) valor, d.data, t.name AS categoria " <<
       "FROM transactions d, taggings tg, tags t " <<
       "WHERE d.user_id = ? AND (d.data BETWEEN ? AND ?) AND d.id = tg.taggable_id AND " <<
          "tg.taggable_type = 'Transactions' AND tg.tag_id = t.id AND d.tipo = ? " <<
       "GROUP BY d.data, t.name " <<
       "ORDER BY t.name, d.data", 
      get_user_id, start_date, end_date, tipo])
    
    #@debug = ""
    i = 0
    cat_hash = Hash.new
    @depesas.collect do |dp|
      if(cat_hash[dp.categoria].nil?)
        cat_hash.store(dp.categoria, Hash.new)
      end
      
      @list_dates.collect do |dt|
        i += 1
        if((cat_hash[dp.categoria][dt.data].nil?) || (cat_hash[dp.categoria][dt.data] == 0))
          if(dt.data == dp.data)
            cat_hash[dp.categoria].store(dp.data, dp.valor)
            #@debug += i.to_s + " - " + dp.categoria.to_s + " | " + dt.data.to_s + " = " + cat_hash[dp.categoria][dt.data].to_s + "<br />"
            #puts i.to_s + " - " + dp.categoria.to_s + " | " + dt.data.to_s + " = " + cat_hash[dp.categoria][dt.data].to_s
          else
            #@debug += i.to_s + " - " + dp.categoria.to_s + " | " + dt.data.to_s + " = " + cat_hash[dp.categoria][dt.data].to_s + "<br />"            
            cat_hash[dp.categoria].store(dt.data, 0)            
          end
        end
      end
    end

    cat_hash.collect do |cat|
      g.data(cat[0], cat[1].sort{|x,y| x[0] <=> y[0]}.collect {|i| i[1]})
    end
       
    j = 0
    hash = Hash.new
    
    @list_dates.collect do |d|
      hash.store(j, d.data.day.to_s)
      j += 1
    end
    
    g.labels = hash
    g.write(RAILS_ROOT + "/public/graphs/" + get_user_id.to_s + "_" + file_name)  
  end
  
  def generate_receita
    g = Gruff::Line.new
    g.title = "Financeiro - " << start_date.strftime('%m/%Y')
    
    @receitas = Transactions.find_by_sql(
      ["SELECT SUM(d.valor) valor, d.data FROM transactions d WHERE d.user_id = ? AND " <<
        "(d.data BETWEEN ? AND ?) AND d.tipo = ? GROUP BY d.data ORDER BY d.data", 
      get_user_id, start_date, end_date, 'r'])
      
    g.data("Receitas", @receitas.collect {|d| d.valor})
    
    j = 0    
    hash = Hash.new
       
    @receitas.collect do |d|
      hash.store(j, d.data.day.to_s)
      j += 1      
    end
    
    g.labels = hash    
    g.write(RAILS_ROOT + "/public/graphs/" + get_user_id.to_s + "_receita.png")
  end
  
  private
    def start_date
      dt_ini = Date.civil(
        params[:despesa]["data(1i)"].to_i,
        params[:despesa]["data(2i)"].to_i,
        1) 
    end
    
    def end_date
      dt_fim = Date.civil(
        params[:despesa]["data(1i)"].to_i,
        params[:despesa]["data(2i)"].to_i + 1,
        1)
      
      dt_fim -= 1    
    end

end
