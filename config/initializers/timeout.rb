if defined? Rack::Timeout
  Rack::Timeout.timeout = ENV.fetch('RACK_TIMEOUT') { 20  }.to_i  # seconds
end
