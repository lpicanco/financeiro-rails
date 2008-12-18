class Transactions < ActiveRecord::Base
  
  belongs_to :account
  
  validates_presence_of(:descricao, :message => "A descrição é obrigatória") 
  acts_as_taggable
  
  def self.get_by_tag(user_id, start_date, end_date, tipo)      
    find_by_sql(
      ["SELECT t.name, SUM(d.valor) valor FROM transactions d, taggings tg, tags t WHERE " <<
      "d.user_id = ? AND (d.data BETWEEN ? AND ?) AND d.id = tg.taggable_id AND " << 
      "tg.taggable_type = ? AND tg.tag_id = t.id AND d.tipo = ? GROUP BY t.name ORDER BY t.name", 
      user_id, start_date, end_date, self.to_s, tipo])
  end
  
  def formated_value
    value = valor
    
    if tipo == "d" 
      value = -valor
    end
      
    value
  end
end
