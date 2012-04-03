require 'spec_helper'


describe ExtraLoop::ScraperBase do
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
    context "with a symbol as the 'model' parameter value" do
      before do 
        received_records = nil

        @scraper.
          set_storage(:MyRecord) { |records| received_records = records }.
          run()

        @received_records = received_records
      end

      it "Should dynamically create 'MyRecord' class" do
        @received_records.all? { |record| record.is_a?(MyRecord) }.should be_true
      end

      it "All records should be associated to the same ScrapingSession object" do
        @received_records.all? { |record| record.session.should be_eql @scraper.session }
      end

      it "Should auto assign a session title" do
        @scraper.session.title.should match /^(\d)*\s(MyRecord)\sDataset$/
      end
    end

    context "with a constant as the 'model' parameter value" do
      before do 
        received_records = nil

        class MyModel < ExtraLoop::Storage::Record
          attribute :foo
        end

        @scraper.
          set_storage(MyModel) { |records| received_records = records }.
          run()

        @received_records = received_records
      end

      it "All records should be instances of MyModel" do
        @received_records.all? { |record| record.is_a?(MyModel) }.should be_true
      end

      it "All records should be associated to the same ScrapingSession object" do
        @received_records.all? { |record| record.session.should be_eql @scraper.session }
      end

      it "Should auto assign a session title" do
        @scraper.session.title.should match /^(\d)*\s(MyModel)\sDataset$/
      end
    end
  end

  context "with a constant name and no block" do
    before do 
      received_records = nil

      if !Object.const_defined? :MyModel
        class MyModel < ExtraLoop::Storage::Record
          attribute :foo
        end
      end

      @scraper.
        set_storage(MyModel).
        run()

      @received_records = received_records
    end

    it "should persist 10 records" do
      @scraper.session.records.should have(10).records
      @scraper.session.records.map(&:id).reject(&:nil?).should_not be_empty
    end
  end
end

