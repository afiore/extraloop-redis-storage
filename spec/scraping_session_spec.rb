$VERBOSE=nil
require "helpers/spec_helper"

describe ExtraLoop::Storage::ScrapingSession do

  describe "#records" do
    before(:each) do
      my_collection = ExtraLoop::Storage::DatasetFactory.new(:MyCollection).get_class
      @model = ExtraLoop::Storage::Model[:MyCollection]
      @session = ExtraLoop::Storage::ScrapingSession.create :model => @model
      5.times do
        item = my_collection.create(:session => @session)
      end
    end

    context "dataset class exists" do
      context "passing a constant" do
        subject { @session.records }
        it { should have(5).items  }
        it { subject.all? { |record| record.valid? }.should be_true }
      end
    end

  end
end
