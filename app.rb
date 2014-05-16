require 'sinatra'
require 'sinatra/base'
require 'sinatra/content_for'

Dir.glob('./app/{controllers,services,models,lib}/*.rb').each { |file| require file }

module HazCommitz
  class App < Sinatra::Application
    configure :production do
      # ...
    end

    configure :development, :test do
      set :raise_errors, false
      set :show_exceptions, false
    end

    use HazCommitz::RootController
    use HazCommitz::ReposController
  end
end
