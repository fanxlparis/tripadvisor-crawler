require "spec_helper"
require "tripadvisor"

describe Tripadvisor::Models::PrefecturePage do
  before(:each) do
    name = "Tokyo"
    uri = "http://www.tripadvisor.com/AllLocations-g1023181-c1-Hotels-Tokyo_Prefecture_Kanto.html"

    @obj = Tripadvisor::Models::PrefecturePage.new(name, uri)
  end


  describe "new" do
    it "should be a new instance" do
      @obj.class.to_s.should == "Tripadvisor::Models::PrefecturePage"
    end
  end

  describe "get_document" do
    it "should be able to request http" do
      result = @obj.get_document
      result.to_s.should =~ /html/
    end
  end

  describe "get_lodging_links" do
    it "should be an array and has elements" do
      @obj.get_document
      result = @obj.get_lodging_links
      result.class.to_s.should == "Array"
      result.length.should > 0
    end
  end

end
