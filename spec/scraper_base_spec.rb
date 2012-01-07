load "../lib/extraloop/redis-storage.rb"

describe ExtraLoop::ScraperBase do
  Ohm.connect :url => "redis://127.0.0.1:6379/7"

  describe "#set_storage" do
  end
end

