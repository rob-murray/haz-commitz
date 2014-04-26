require "sinatra"
require "json"

module HazCommitz
    class BaseController < Sinatra::Base

        configure do
            set :views, 'app/views'
            set :public_folder, 'app/public'
            set :show_exceptions, false
        end

        private

        def github_api_token
            HazCommitz.github_token || ''
        end

    end
end