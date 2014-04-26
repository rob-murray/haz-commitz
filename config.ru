require 'rubygems'
require 'bundler'
Bundler.require(:default, ENV['RACK_ENV'].to_sym)

require './app'
require './app/haz_commitz'

HazCommitz.github_token = ENV['GITHUB_TOKEN'] || nil
run HazCommitz::App
