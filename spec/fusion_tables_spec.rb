require '../lib/extraloop/redis-storage'
require './helpers/spec_helper'
require 'gdata'

class MyRecord < ExtraLoop::Storage::Record
  attribute :index
end

describe ExtraLoop::Storage::FusionTables do
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
    
    @fusion_table = ExtraLoop::Storage::FusionTables.new ["username","password"] 
    @fusion_table.push(@dataset)
  end

  describe "#push" do
    it "should name the table with a string starting with 'Dataset'" do
      @title.should match /^Dataset/
    end
    it "table schema should include 'session_id' with type 'number'" do
      @fields.should include :name => 'session_id', :type => 'number'
    end
    it "table schema should not include 'session_id' with type 'string'" do
      @fields.should_not include :name => 'session_id', :type => 'string'
    end
  end
end
