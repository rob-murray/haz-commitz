require_relative 'base_controller'

module HazCommitz
    class RootController < BaseController

        get '/' do
            erb :root
        end
        
    end
end