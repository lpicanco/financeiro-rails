class CategoriesController < ApplicationController

  def list
    @tag_despesas = Tag.tags(:user => current_user, :taggable_type => 'Transactions', :limit => 100, :order => "name desc")
    @tag_receitas = Tag.tags(:user => current_user, :taggable_type => 'Transactions', :limit => 100, :order => "name desc")    
  end
end
