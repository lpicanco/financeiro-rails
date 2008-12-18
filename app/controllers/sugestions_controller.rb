class SugestionsController < ApplicationController
  
  ajax_scaffold :sugestion, :rows_per_page => 10
  
  @@scaffold_columns = [          
          AjaxScaffold::ScaffoldColumn.new(Despesa, { :name => "nome",
            :eval => "row.nome", :sort => 'nome' }),
          AjaxScaffold::ScaffoldColumn.new(Despesa, { :name => "e-mail",
            :eval => "row.email", :sort => 'email' }),
          AjaxScaffold::ScaffoldColumn.new(Despesa, { :name => "sugestao", 
            :eval => "row.sugestao", :sort => 'sugestao' })
  ]
end
