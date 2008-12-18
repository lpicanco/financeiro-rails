class Sugestion < ActiveRecord::Base
  validates_presence_of(:sugestao, :message => "A sugestão é obrigatória")  
end
