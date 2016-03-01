require 'rubygems'
require 'bundler'

Bundler.require(:default)
Bundler.require(Sinatra::Base.environment)

require "sinatra/reloader" if development?
require "sinatra/activerecord"

module PageConfig
  module Api 
    class Base < Sinatra::Base
      register Sinatra::ActiveRecordExtension

      configure :development do
        register Sinatra::Reloader
      end

      configure do
        set :database, { 
          adapter: "sqlite3", 
          database: test? ? "page_config_test.sqlite3" : "page_config.sqlite3"
        }
        disable :method_override
        disable :static
      end

      configure :development, :staging do
        database.logger = Logger.new(STDOUT)
        database.logger.level = Logger::INFO
      end

      not_found do
        {error: 'Invalid URL.'}.to_json
      end
    end

  end
end
