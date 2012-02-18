load "../lib/extraloop/redis-storage.rb"


describe ExtraLoop::ScraperBase do
  Ohm.connect :url => "redis://127.0.0.1:6379/7"

  before(:each) do
    @records = records =  (1..10).to_a.map { |n| OpenStruct.new :foo => "foo#{n}" }
    @scraper = ExtraLoop::ScraperBase.new("http://someurl.net").
      loop_on("*").
        extract(:foo).
        extract(:bar)

    env = ExtraLoop::ExtractionEnvironment.new(@scraper, nil, @records)

    @scraper.define_singleton_method :run do
      @environment = env
      self.run_hook :data, [records]
    end
  end

  describe "#set_storage" do
    context "with no arguments but a block" do
      before do 
        received_records = nil

        @scraper.
          set_storage { |records| received_records = records }.
          run()

        @received_records = received_records
      end
      it "all records should be openstruct instances" do
        @received_records.all? { |record| record.is_a?(Extraloop_scraperbase_data) }.should be_true
      end
    end

    context "with title argument and no block" do
      before do
        @scraper.set_storage "my dummy dataset"
      end
    end
  end
end

