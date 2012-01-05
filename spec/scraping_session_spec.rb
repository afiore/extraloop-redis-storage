$VERBOSE=nil
load "../lib/extraloop/redis-storage.rb"

describe ExtraLoop::Storage::ScrapingSession do
  Ohm.connect :url => "redis://127.0.0.1:6379/7"

  describe "#records" do
    before(:each) do
      my_collection = ExtraLoop::Storage::DatasetFactory.new(:MyCollection).get_class
      @session = ExtraLoop::Storage::ScrapingSession.create
      5.times { my_collection.create :session => @session }
    end

    context "dataset class exists" do

      context "passing a symbol" do
        subject { @session.records(:MyCollection) }
        it { should have(5).items  }
        it { subject.all? { |record| record.valid? }.should be_true }
      end

      context "passing a string" do
        subject { @session.records('MyCollection') }
        it { should have(5).items  }
        it { subject.all? { |record| record.valid? }.should be_true }
      end
    end

    after do
      patterns = ["Mycollection", "ExtraLoop"]
      patterns.each { |pattern| Ohm.redis.keys("*#{pattern}*").each { |key| Ohm.redis.del(key)} }
    end
  end
end
