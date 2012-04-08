require "spec_helper"

class MyRecord < ExtraLoop::Storage::Record
  attribute :foo
  attribute :bar
  counter :n
  index :bar
end

describe ExtraLoop::Storage::Record do

  before do
    @session = ExtraLoop::Storage::ScrapingSession.create :model => ExtraLoop::Storage::Model[:MyRecord]
  end

  context "record subclasses" do

    describe "#valid?" do
      subject { @record = MyRecord.new(:foo => 'foo', :bar => 'bar').valid? }
      it { should be_false }
    end

    describe "#errors" do
      before do
        @record = MyRecord.new(:foo => 'foo', :bar => 'bar')
        @record.save
      end

      subject { @record.errors }

      it { should include([:session, :not_present]) }
    end

    describe "#save" do

      subject { MyRecord.new(:session => @session, :extracted_at => Time.now).save }

      it { subject.extracted_at.should be_a_kind_of(Time) }
      it { subject.session.should eql(@session) }

      it "should correctly increment counters" do
        3.times { subject.incr :n }
        subject.n.should eql(3)
      end

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

    describe "#find" do
      before do
        MyRecord.create(:foo => 'foo', :bar => 'bar', :session => @session)
        MyRecord.create(:foo => 'foo', :bar => 'bar', :session => @session)
        @target = MyRecord.create(:foo => 'foo', :bar => 'foo', :session => @session)
        MyRecord.create(:foo => 'foo', :bar => 'bar', :session => @session)
      end

      subject { MyRecord.find(:bar => 'foo').first }
      it { should eql(@target) }
    end

    describe "Record::last" do
      before do
        2.times { MyRecord.create(:session => @session) }
      end

      subject { MyRecord }
      it { should respond_to :last }
    end

    describe "#to_hash" do
      before do
        @record = MyRecord.create :foo => 'blurbzz', :bar => 'zzzzzz', :session => @session
      end

      subject { @record.to_hash }

      it "should have converted its attributes as hash keys" do
        [:session_id, :foo, :bar, :created_at, :updated_at].each { |key|  subject.should have_key(key) and subject[key].should_not be_nil }
      end

      context "excluding attributes" do

        before do
          @user_class = Class.new(ExtraLoop::Storage::Record) do
            attribute :password
            attribute :username

            def to_hash
              super.reject { |attr| attr === :password }
            end
          end
        end

        subject { @user_class.create(:session => @session, :username => 'bob', :password => 'secret' ).to_hash }

        it { should_not have_key(:password) }
        it { should have_key(:username) }
        it { should have_key(:session_id) }
      end
    end
  end
end
