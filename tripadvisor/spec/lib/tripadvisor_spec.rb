require "spec_helper"
require "tripadvisor"

describe Tripadvisor do

  describe "constant" do
    it "should be URI_I18N" do
      Tripadvisor::BASE_URI_I18N.should == {
          :US => "http://www.tripadvisor.com/",
          :JP => "http://www.tripadvisor.jp/"
        } 
    end

    it "should be :US" do
      Tripadvisor::DEFAULT_LANG.should == :US
    end

    it "should be http://www.Tripadvisor.com/" do
      Tripadvisor::DEFAULT_BASE_URI.should == "http://www.tripadvisor.com/"
    end
  end

end
