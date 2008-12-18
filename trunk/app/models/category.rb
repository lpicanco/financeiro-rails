class Category < ActiveRecord::Base
  validates_presence_of(:name, :message => "O nome é obrigatório")
end
