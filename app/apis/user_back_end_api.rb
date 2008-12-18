class UserStruct < ActionWebService::Struct
  member :id, :int
  member :login, :string
  member :password, :string
  member :first_name, :string
  member :last_name, :string
end

class UserBackEndApi < ActionWebService::API::Base
  api_method :authenticate,
    :expects => [{:login => :string}, {:password => :string}],
    :returns => [UserStruct]
end
