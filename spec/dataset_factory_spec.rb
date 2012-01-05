load "../lib/extraloop/redis-storage.rb"

describe ExtraLoop::Storage::DatasetFactory do
  Ohm.connect :url => "redis://127.0.0.1:6379/7"

  describe "#get_class" do
    context "with invalid input" do
      before do 
        @factory = ExtraLoop::Storage::DatasetFactory.new(:blurb, [:a, :b, :c])
      end

      subject { @factory.get_class.new :a => 22, :b => 33, :c => 44 }

      it { should respond_to :a }
      it { should respond_to :b }
      it { should respond_to :c }
      it { should respond_to :save }
      it { subject.valid?.should be_false }

      after do
        Object.send(:remove_const, :Blurb)
      end
    end

    context "with valid input" do
      before do 
        @factory = ExtraLoop::Storage::DatasetFactory.new(:blurb, [:a, :b, :c])
        @session = ExtraLoop::Storage::ScrapingSession.create
      end

      subject { @factory.get_class.new :session => @session }
      it { subject.valid?.should be_true }

    end


    after do
      patterns = ["Mycollection", "ExtraLoop"]
      patterns.each { |pattern| Ohm.redis.keys("*#{pattern}*").each { |key| Ohm.redis.del(key)} }
    end

 end
end
