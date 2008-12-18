class MainTabnav < Tabnav::Base    
       
    include Reloadable;
       
    add_tab do 
      named 'Despesas'
      links_to :controller => 'despesas', :action => 'list'
    end 

    add_tab do 
      named 'Receitas'
      links_to :controller => 'receitas', :action => 'list'
    end
    
    add_tab do 
      named 'Consolidado'
      links_to :controller => 'consolidado', :action => 'list'
    end

    add_tab do 
      named 'Contas'
      links_to :controller => 'accounts', :action => 'list'
    end
    
    # TODO: Consertar a visualização das categorias
    #add_tab do 
    #  named 'Categorias'
    #  links_to :controller => 'categories', :action => 'list'
    #end
    
    # TODO: Consertar gráficos
    add_tab do 
      named 'Gráficos'      
      links_to :controller => 'reports', :action => 'index'
    end
    
    add_tab do 
      named 'Ferramentas'
      links_to :controller => 'ferramentas', :action => 'index'
    end
    
    add_tab do 
      named 'Sugestões'
      links_to :controller => 'sugestions', :action => 'list'
    end
end