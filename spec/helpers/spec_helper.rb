RSpec.configure do |config|
  config.mock_with :rr
end


require 'pry'
Ohm.connect :url => "redis://127.0.0.1:6379/7"
