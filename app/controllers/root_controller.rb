require_relative 'base_controller'

module HazCommitz
    class RootController < BaseController

        get '/' do
            erb :root
        end

        get '/add' do
            erb :add
        end
        
    end
end