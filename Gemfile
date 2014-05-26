source 'https://rubygems.org'

ruby '2.1.1'

gem 'rails', '4.1.1'

# No DB but just stick with AR and sqlite3 for now
gem 'sqlite3'

gem 'sass-rails', '~> 4.0.3'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 2.0'

gem 'unicorn'

group :staging, :production do
  gem 'rails_12factor'
end

group :development, :test do
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'rspec-rails'
  gem 'guard-rspec'
  gem "coveralls", "~> 0.7", require: false
  gem 'mocha'
  gem 'shoulda-matchers'
  gem 'capybara'
end

# Application specific
gem 'octokit', '~> 3.1'
gem 'faraday-http-cache'
