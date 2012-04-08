require 'spec_helper'

describe ExtraLoop::Storage::Model do
  describe "::[]()" do
    before do
      @model = ExtraLoop::Storage::Model[:My_model]
    end

    it "should create a record with 'My_model' as an id" do
      @model.id.should eql('My_model')
    end
    

    it "should throw an argument error if the model id is not capitalized" do
      lambda { ExtraLoop::Storage::Model[:my_model] }.should raise_error(ArgumentError)
    end

    it "should throw an argument error if the model id contains spaces" do
      lambda { ExtraLoop::Storage::Model['Bla bla'] }.should raise_error(ArgumentError)
    end
  end
end
