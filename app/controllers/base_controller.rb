require "sinatra"
require "json"

module HazCommitz
    class BaseController < Sinatra::Base
        helpers Sinatra::ContentFor

        configure do
            set :views, 'app/views'
            set :public_folder, 'app/public'
            set :show_exceptions, false
        end

        helpers do
            include Rack::Utils

            alias_method :h, :escape_html

            def render_partial(name, locals = {})
                erb "partials/_#{name}".to_sym, layout: false, locals: locals
            end

            def base_url
                @base_url ||= "#{request.env['rack.url_scheme']}://#{request.env['HTTP_HOST']}"
            end
        end

        private

        def github_api_token
            HazCommitz.github_token || ''
        end

    end
end