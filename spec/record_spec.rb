load "../lib/extraloop/redis-storage.rb"

class MyRecord < ExtraLoop::Storage::Record
  attribute :foo
  attribute :bar
end


describe ExtraLoop::Storage::Record do

  before do
    @session = ExtraLoop::Storage::ScrapingSession.create
  end

  context "record subclasses" do

    describe "#save" do

      subject { MyRecord.new(:session => @session, :extracted_at => Time.now).save }
    
      it { subject.extracted_at.should be_a_kind_of(Time) }
      it { subject.session.should eql(@session) }

      context "without a session attribute" do
        subject { MyRecord.new  }
        it { subject.valid?.should_not be_true }
      end
    end

    describe "#create" do
      subject { MyRecord.create(:session => @session, :extracted_at => Time.now) }
      it { subject.extracted_at.should be_a_kind_of(Time) }
      it { subject.session.should eql(@session) }
    end

  end
end
