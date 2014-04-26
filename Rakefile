require 'rspec/core'
require 'rspec/core/rake_task'
 
task :default => :spec
 
desc "Run all specs in spec directory (excluding plugin specs)"
RSpec::Core::RakeTask.new(:spec)

desc "Run locally"
task :server do |t, args|
    ENV['RACK_ENV'] = 'development'

    require 'rubygems'
    require 'bundler'
    Bundler.require(:default, ENV['RACK_ENV'].to_sym)

    require './app'
    require './app/haz_commitz'

    HazCommitz.github_token = ENV['GITHUB_TOKEN'] || nil
    HazCommitz::App.run!
    
end