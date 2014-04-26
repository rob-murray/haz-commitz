require 'sinatra'
require 'sinatra/base'

Dir.glob('./app/{controllers,services,models,lib}/*.rb').each { |file| require file }

module HazCommitz
  class App < Sinatra::Application
    #enable :sessions

    configure :production do
      set :raise_errors, false
      set :show_exceptions, false
    end

    configure :development do
      set :raise_errors, false
      set :show_exceptions, false
    end
    
    use HazCommitz::RootController
    use HazCommitz::ReposController

    helpers do
      include Rack::Utils
      alias_method :h, :escape_html
    end
  end
end
