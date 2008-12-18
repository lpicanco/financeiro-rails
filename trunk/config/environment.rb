# Be sure to restart your web server when you modify this file.

# Uncomment below to force Rails into production mode when 
# you don't control web/app server and can't set it the proper way
ENV['RAILS_ENV'] = 'development'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '1.2.3'

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence those specified here
  
  # Skip frameworks you're not going to use
  # config.frameworks -= [ :action_web_service, :action_mailer ]

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Force all environments to use the same logger level 
  # (by default production uses :info, the others :debug)
  # config.log_level = :debug

  # Use the database for sessions instead of the file system
  # (create the session table with 'rake db:sessions:create')
  # config.action_controller.session_store = :active_record_store

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper, 
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector

  # Make Active Record use UTC-base instead of local time
  # config.active_record.default_timezone = :utc
  
  # See Rails::Configuration for more options
end

# Add new inflection rules using the following format 
# (all these examples are active by default):
# Inflector.inflections do |inflect|
#   inflect.plural /^(ox)$/i, '\1en'
#   inflect.singular /^(ox)en/i, '\1'
#   inflect.irregular 'person', 'people'
#   inflect.uncountable %w( fish sheep )
# end

# Include your application configuration below

module LoginEngine
  config :salt, "your-salt-here"
  config :use_email_notification, false
end

Engines.start :login

Date::MONTHNAMES = [nil] + %w(Janeiro Fevereiro Mar�o Abril Maio Junho Julho Agosto Setembro Outubro Novembro Dezembro)     
Date::DAYNAMES = %w(Domingo Segunda-Feira Ter�a-Feira Quart-Feira Quinta-Feira Sexta-Feira S�bado)     
Date::ABBR_MONTHNAMES = [nil] + %w(Jan Fev Mar Abr Mai Jun Jul Aug Sep Out Nov Dez)     
Date::ABBR_DAYNAMES = %w(Dom Seg Ter Qua Qui Sex Sab)     
   
class Time    
  alias :strftime_nolocale :strftime    
  
  def strftime(format)     
    format = format.dup     
    format.gsub!(/%a/, Date::ABBR_DAYNAMES[self.wday])     
    format.gsub!(/%A/, Date::DAYNAMES[self.wday])     
    format.gsub!(/%b/, Date::ABBR_MONTHNAMES[self.mon])     
    format.gsub!(/%B/, Date::MONTHNAMES[self.mon])     
    self.strftime_nolocale(format)     
  end    
end

class Float
  def formated
    value_string = format("%.2f", self)
    value_string.gsub(/\./, ",")
  end
end

class Fixnum
  def formated
    to_s
  end
end
