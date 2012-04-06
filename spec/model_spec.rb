require 'spec_helper'

describe ExtraLoop::Storage::Model do
  describe "::[]()" do
    before do
      @model = ExtraLoop::Storage::Model[:My_model]
    end

    it "should create a record if a model with id 'my_model' does not exist" do
      @model.should eql(ExtraLoop::Storage::Model[:My_model])
    end

    it "should throw an argument error if the model id is not capitalized" do
      lambda { ExtraLoop::Storage::Model[:my_model] }.should raise_error(ArgumentError)
    end
  end
end
