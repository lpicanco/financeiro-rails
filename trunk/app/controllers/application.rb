require 'login_engine'

class ApplicationController < ActionController::Base
  include LoginEngine
  helper :user
  model :user
  
  #before_filter :login_required
  before_filter :set_encoding
  
  #inicializa o ICONV
  ICONV = Iconv.new('ISO-8859-1', 'UTF-8')  
  
  def get_user_id
    user_id = 0
    
    unless current_user.nil?
      user_id = current_user.id
    end
    
    user_id  
  end  

  private
    def set_encoding
      
      #testa se é uma requisição AJAX
      if request.xhr?
        @response.headers["Content-Type"] ||= "text/javascript; charset=ISO-8859-1"
        
        #converte os parametros do form ajax
        convert_hash(params)
      else
        @headers["Content-Type"] = "text/html; charset=ISO-8859-1"
        suppress(ActiveRecord::StatementInvalid) do
          ActiveRecord::Base.connection.execute 'SET NAMES ISO-8859-1'
        end
      end      
    end
    
    def convert_hash(hash)
      for k, v in hash
        case v
          when String: hash[k] = ICONV.iconv(v)
          when Array: hash[k] = v.collect { |v| ICONV.iconv(v) }
          when Hash: convert_hash(v)
        end
      end
    end    
end

ActiveSupport::CoreExtensions::Time::Conversions::DATE_FORMATS.merge!(
  :default => "%d/%m/%Y",
  :date_time12 => "%d/%m/%Y %I:%M%p"  ,
  :date_time24 => "%d/%m/%Y %H:%M"
)