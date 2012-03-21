load '../lib/extraloop/redis-storage.rb'
require './helpers/spec_helper'


class MyRecord < ExtraLoop::Storage::Record
  attribute :index
end

describe ExtraLoop::Storage::Cartodb do
  before do
    @remote_store = ExtraLoop::Storage::RemoteStore.get_transport(:cartodb, {
      :host => "https://afiore.cartodb.com",
      :oauth_key => "9EidEcxvIzMOuLDHeHMQuZuTUJgqNhB4IlMkprS5",
      :oauth_secret => "nY03FyIonRZo7Pztv2IACdAHc29PGH9Iw3PGeW4D",
      :username => "afiore",
      :password => "polmone"
    })
  end

  before(:each) do

    model = ExtraLoop::Storage::Model.create :name => MyRecord.to_s
    @dataset = ExtraLoop::Storage::ScrapingSession.create :title => "test dataset #{Time.now.to_i}", :model => model

    5.times do |n|
      MyRecord.create :index => n, :session => @dataset 
    end
  end

  describe "#push" do
    it "should ..." do
      @remote_store.push(@dataset)
      true.should be_false
    end
    
  end
end

