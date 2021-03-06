require 'spec_helper'
include ExtraLoop::Storage

class Entry < Record
  extend IdKey
  attribute :name
  attribute :foo
  index :foo
end

def session
  ScrapingSession.create(
    :title => 'test',
    :model => Model[:Entry],
  )
end

describe Entry do
  describe "::[]()" do

    context "with invalid key" do
      it "should raise an error when the id key contains spaces" do
        lambda { Entry['hello world'] }.should raise_error(ArgumentError)
      end
    end

    context "with a symbol as key" do
      before { @entry = Entry['foo', {:session => session, :foo => 'foo' } ] }

      it "should cast the id as a string" do
        @entry.id.should eql('Entry:foo')
      end
    end

    context "with a generated id as argument" do
      before do
        @entry = Entry['fufu']
      end

      subject { Entry[@entry.id] }
      it { should eql(@entry) }
      it { should eql(Entry['fufu'])}
    end

    context "without arguments" do
      before do
        @entry = Entry['foo']
      end

      it "should initialize a record with id 'entry:foo'" do
        @entry.id.should eql('Entry:foo')
      end

      it "should initialize the same record" do
        Entry['foo'].should eql(@entry)
      end
    end

    context "with an attribute hash as its second argument" do
      before do
        @entry = Entry['foo', {:session => session, :foo => 'foo' }]
      end

      it "should persist the record" do
        @entry.valid?.should be_true
      end

      it "should assign a value to the 'foo' attribute " do
        @entry.foo.should eql('foo')
      end

      it "should not create duplicates" do
        10.times do
          Entry['foo', {:session => session, :foo => 'foo' } ]
        end

        Entry.find(:foo => 'foo').should include(@entry)
        Entry.find(:foo => 'foo').should have(1).item
      end

      it "should update the record with the hash content" do
        Entry['foo', {'foo' => 'bar'}]
        Entry['foo'].foo.should eql('bar')
        Entry.all.map(&:id).grep(/foo$/).should have(1).item
      end
    end
  end

  describe "::create" do

  end

  describe "#save" do
    context "with an entry initialized through the '[]' method" do
      before do
        @entry = Entry['hello-test', {session: session}]
        @entry.foo = 'test'
        @entry.save
      end

      it "should retain the initial id when calling save" do
        @entry.id.should eql('Entry:hello-test')
        Entry['hello-test'].foo.should eql('test')
      end
    end
  end
end
