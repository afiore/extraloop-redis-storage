load "../lib/extraloop/redis-storage.rb"


describe ExtraLoop::ScraperBase do
  Ohm.connect :url => "redis://127.0.0.1:6379/7"

  before(:each) do
    @records = (1..10).to_a.map { OpenStruct.new }
    @scraper = ExtraLoop::ScraperBase.new("http://someurl.net").
      loop_on("*").
        extract(:foo).
        extract(:bar)
  end

  describe "#set_storage" do
    context "with no arguments but a block" do

      before do 
        all_records_are_openstruct = false
        records = @records

        @scraper.set_storage do |records|
          all_records_are_openstruct = records.all? { |record| record.is_a?(OpenStruct) }
        end


        @scraper.define_singleton_method(:run) do
          self.run_hook(:data, [records])
        end
        @scraper.run
        @all_records_are_openstruct = all_records_are_openstruct
      end

      it "all records should be openstruct instances" do
        @all_records_are_openstruct.should be_true
      end

    end




  end
end

