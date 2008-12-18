# Don't change this file. Configuration is done in config/environment.rb and config/environments/*.rb

unless defined?(RAILS_ROOT)
  root_path = File.join(File.dirname(__FILE__), '..')

  unless RUBY_PLATFORM =~ /(:?mswin|mingw)/
    require 'pathname'
    root_path = Pathname.new(root_path).cleanpath(true).to_s
  end

  RAILS_ROOT = root_path
end

unless defined?(Rails::Initializer)
  if File.directory?("#{RAILS_ROOT}/vendor/rails")
    require "#{RAILS_ROOT}/vendor/rails/railties/lib/initializer"
  else
    require 'rubygems'

    environment_without_comments = IO.readlines(File.dirname(__FILE__) + '/environment.rb').reject { |l| l =~ /^#/ }.join
    environment_without_comments =~ /[^#]RAILS_GEM_VERSION = '([\d.]+)'/
    rails_gem_version = $1

    if version = defined?(RAILS_GEM_VERSION) ? RAILS_GEM_VERSION : rails_gem_version
      # Asking for 1.1.6 will give you 1.1.6.5206, if available -- makes it easier to use beta gems
    begin
      gem "rails", rails_gem_version
      gem_dir = Gem.path.select{|p| File.directory?("#{p}/gems/rails-#{rails_gem_version}")}.first
      require "#{gem_dir}/gems/rails-#{rails_gem_version}/lib/initializer"
    rescue Gem::LoadError => load_error
      $stderr.puts %(Missing the Rails #{rails_gem_version} gem. Please `gem install -v=#{rails_gem_version} rails`, update your RAILS_GEM_VERSION setting in config/environment.rb for the Rails version you do have installed, or comment out RAILS_GEM_VERSION to use the latest version installed.)
      exit 1
    end
    else
      gem "rails"
      require 'initializer'
    end
  end

  Rails::Initializer.run(:set_load_path)
end
