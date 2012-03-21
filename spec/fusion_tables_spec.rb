require 'helpers/spec_helper'
require 'gdata'

class MyRecord < ExtraLoop::Storage::Record
  attribute :index
end

describe ExtraLoop::Storage::FusionTables do

  describe "#push" do

    before do
      model = ExtraLoop::Storage::Model.create :name => MyRecord.to_s
      @dataset = ExtraLoop::Storage::ScrapingSession.create :title => 'test dataset', :model => model

      5.times do |n|
        MyRecord.create :index => n, :session => @dataset 
      end

      table=Object.new
      mock(table).insert(@dataset.to_hash[:records])

      any_instance_of(GData::Client::FusionTables) do |ft|
        mock(ft).clientlogin(is_a(String), is_a(String)).times(any_times)
        stub(ft).create_table { |title, fields|
          @title = title
          @fields = fields

          table
        }
      end
    end

    context "without a schema definition" do

      before do
        @fusion_table = ExtraLoop::Storage::FusionTables.new :username => 'username', 'password' => "password"
        @fusion_table.push(@dataset)
      end

      it "should name the table with a string starting with 'Dataset'" do
        @title.should match /^Dataset/
      end

      subject { @fields }

      it { should include :name => 'session_id', :type => 'number' }
      it { should_not include :name => 'session_id', :type => 'string' }
      it { should include :name => 'index', :type => 'string' }
      it { should include :name => 'id', :type => 'number' }

    end

    context "with a schema definition" do

      before do
        @fusion_table = ExtraLoop::Storage::FusionTables.new(["username","password"], {:schema => {:session_id => 'string', :index => 'number'}})
        @fusion_table.push(@dataset)
      end

      subject { @fields }

      it { should_not include :name => 'session_id', :type => 'number' }
      it { should include :name  => 'session_id', :type => 'string' }
      it { should include :name  => 'index', :type => 'number' }
    end
  end
end
