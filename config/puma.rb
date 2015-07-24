workers ENV.fetch('PUMA_WORKERS') { 3 }.to_i
threads_count = ENV.fetch('MAX_THREADS') { 5 }.to_i
threads threads_count, threads_count

rackup DefaultRackup
port ENV.fetch('WEB_PORT') { ENV['PORT'] || 5000 }.to_i
environment ENV.fetch('RACK_ENV') { 'development' }
preload_app!

on_worker_boot do
  # puma worker specific setup

  # Valid on Rails 4.1+ using the `config/database.yml` method of setting `pool` size
  ActiveRecord::Base.establish_connection
end
