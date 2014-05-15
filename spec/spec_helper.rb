require 'rubygems'
require 'spork'
require 'coveralls'

# force the environment to 'test'
ENV['RACK_ENV'] = 'test'

Coveralls.wear! # Code coverage

Dir.glob('./spec/support/{helpers}/*.rb').each { |file| require file }

Spork.prefork do
  require_relative '../app'
  require_relative '../app/haz_commitz'
  Dir.glob('./app/{controllers,services,models,lib}/*.rb').each { |file| require file }

  require 'rubygems'
  require 'sinatra'
  require 'rspec'
  require 'rack/test'
  require 'webrat'

  # test environment stuff
  Sinatra::Base.set :environment, :test
  Sinatra::Base.set :run, false
  Sinatra::Base.set :raise_errors, false
  Sinatra::Base.set :logging, false

  RSpec.configure do |config|
    config.treat_symbols_as_metadata_keys_with_true_values = true
    config.run_all_when_everything_filtered = true
    config.filter_run :focus
    config.mock_framework = :mocha
    config.include DateHelper
    config.include Rack::Test::Methods

    # Run specs in random order to surface order dependencies. If you find an
    # order dependency and want to debug it, you can fix the order by providing
    # the seed, which is printed after each run.
    #     --seed 1234
    config.order = 'random'
  end

  def app
    @app ||= HazCommitz::App
  end
end

Spork.each_run do
end
