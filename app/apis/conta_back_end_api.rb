class ContaStruct < ActionWebService::Struct
  member :id, :int
  member :name, :string
  member :description, :string
end

class ContaBackEndApi < ActionWebService::API::Base
  api_method :list,
    :expects => [{:login => :string}, {:password => :string}],
    :returns => [[ContaStruct]]
    
  api_method :create,
    :expects => [{:login => :string}, {:password => :string}, {:name => :string}, {:description => :string}],
    :returns => [:bool]  
  
  api_method :update,
    :expects => [{:login => :string}, {:password => :string}, {:id => :int}, {:name => :string}, 
                {:description => :string}],
    :returns => [:bool]

  api_method :destroy,
    :expects => [{:login => :string}, {:password => :string}, {:id => :int}],
    :returns => [:bool]    
end
