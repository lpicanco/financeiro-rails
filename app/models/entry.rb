#require 'ajax_scaffold'

class Entry < ActiveRecord::Base

  validates_presence_of(:description, :message => "Entre com a descrição")
  validates_presence_of(:value, :message => "Entre com o valor")
  
  belongs_to :category
  belongs_to :type
  
  @scaffold_columns = [       
    AjaxScaffold::ScaffoldColumn.new(self, { :name => "tipo", :eval => "entry.type.name"}),
    AjaxScaffold::ScaffoldColumn.new(self, { :name => "descrição", :eval => "entry.description"}),
    AjaxScaffold::ScaffoldColumn.new(self, { :name => "categoria", :eval => "entry.category.name"}),
    AjaxScaffold::ScaffoldColumn.new(self, { :name => "valor", :eval => "entry.value"}),
  ]
end
