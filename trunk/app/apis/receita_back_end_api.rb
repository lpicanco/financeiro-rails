class ReceitaStruct < ActionWebService::Struct
  member :id, :int
  member :description, :string
  member :categories, :string
  member :account_id, :int
  member :value, :float
  member :date, :string
end

class ReceitaBackEndApi < ActionWebService::API::Base
  api_method :list,
    :expects => [{:login => :string}, {:password => :string}, {:start_date => :string}, {:end_date => :string}],
    :returns => [[ReceitaStruct]]
  
  api_method :create,
    :expects => [{:login => :string}, {:password => :string}, {:description => :string}, {:categories => :string}, 
                {:account_id => :int}, {:value => :float}, {:date => :string}],
    :returns => [:bool]  
  
  api_method :update,
    :expects => [{:login => :string}, {:password => :string}, {:id => :int}, {:description => :string}, 
                {:categories => :string}, {:account_id => :int}, {:value => :float}, {:date => :string}],
    :returns => [:bool]

  api_method :destroy,
    :expects => [{:login => :string}, {:password => :string}, {:id => :int}],
    :returns => [:bool]
end
