source 'https://rubygems.org'

ruby '2.2.3'

gem 'rails', '4.1.14.1'

# No DB but just stick with AR and pg for now
gem 'pg'

gem 'sass-rails'
gem 'uglifier'
gem 'coffee-rails'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder'

gem 'puma'
gem 'rollbar'

gem 'virtus'

group :staging, :production do
  gem 'rails_12factor'
  gem 'rack-timeout'
end

group :development, :test do
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'rspec-rails'
  gem 'guard-rspec'
  gem 'coveralls', '~> 0.7', require: false
  gem 'shoulda-matchers'
  gem 'capybara'
  gem 'paratrooper' # wrapper for deploying to heroku
  gem 'awesome_print'
  gem 'pry-rails'
  gem 'pry-nav'
  gem 'pry-rescue'
  gem 'pry-byebug'
end

# Application specific
gem 'octokit', '~> 3.1'
gem 'faraday-http-cache'
gem 'five-star'
