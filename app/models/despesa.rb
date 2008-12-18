class Despesa < ActiveRecord::Base
  belongs_to :category
  belongs_to :account
  belongs_to :user
  
  validates_presence_of(:descricao, :message => "A descrição é obrigatória") 
  acts_as_taggable
  
  def self.get_by_tag(user_id, start_date, end_date)      
    Despesa.find_by_sql(
      ["SELECT t.name, SUM(d.valor) valor FROM despesas d, taggings tg, tags t WHERE " <<
      "d.user_id = ? AND (d.data BETWEEN ? AND ?) AND d.id = tg.taggable_id AND " << 
      "tg.taggable_type = ? AND tg.tag_id = t.id GROUP BY t.name ORDER BY t.name", 
      user_id, start_date, end_date, self.to_s])
  end
end
