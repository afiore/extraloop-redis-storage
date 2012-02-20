$VERBOSE=nil
load "../lib/extraloop/redis-storage.rb"

describe ExtraLoop::Storage::ScrapingSession do
  Ohm.connect :url => "redis://127.0.0.1:6379/7"

  describe "#records" do
    before(:each) do
      my_collection = ExtraLoop::Storage::DatasetFactory.new(:MyCollection).get_class
      @session = ExtraLoop::Storage::ScrapingSession.create
      5.times do
        item = my_collection.create(:session => @session)
      end
    end

    context "dataset class exists" do
      context "passing a constant" do
        subject { @session.records(Mycollection) }
        it { should have(5).items  }
        it { subject.all? { |record| record.valid? }.should be_true }
      end
    end

  end
end
