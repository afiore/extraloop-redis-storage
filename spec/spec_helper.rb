require 'pry'
path = File.dirname(File.dirname(__FILE__))
$: << path + "/lib/extraloop"

require "redis-storage"

RSpec.configure do |config|
  config.mock_with :rr

  # flush db content after each test run
  config.after(:all) do
    Ohm.flush
  end
end

ENV['REDIS_URL']= "redis://127.0.0.1:6379/7"
Ohm.connect
