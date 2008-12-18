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
    
    # TODO: Consertar a visualiza��o das categorias
    #add_tab do 
    #  named 'Categorias'
    #  links_to :controller => 'categories', :action => 'list'
    #end
    
    # TODO: Consertar gr�ficos
    add_tab do 
      named 'Gr�ficos'      
      links_to :controller => 'reports', :action => 'index'
    end
    
    add_tab do 
      named 'Ferramentas'
      links_to :controller => 'ferramentas', :action => 'index'
    end
    
    add_tab do 
      named 'Sugest�es'
      links_to :controller => 'sugestions', :action => 'list'
    end
end