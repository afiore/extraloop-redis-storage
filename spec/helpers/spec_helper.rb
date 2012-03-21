require 'pry'
path = File.dirname(File.dirname(File.dirname(__FILE__)))
$: << path + "/lib/extraloop"

require "redis-storage"

RSpec.configure do |config|
  config.mock_with :rr
end

Ohm.connect :url => "redis://127.0.0.1:6379/7"
