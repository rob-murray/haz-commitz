source 'https://rubygems.org'

ruby '2.2.2'

gem 'rails', '4.1.9'

# No DB but just stick with AR and pg for now
gem 'pg'

gem 'sass-rails', '~> 4.0.3'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 2.0'

gem 'unicorn'
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
