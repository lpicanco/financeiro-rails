class Sugestion < ActiveRecord::Base
  validates_presence_of(:sugestao, :message => "A sugest�o � obrigat�ria")  
end
