require "spec_helper"
require "tripadvisor"

describe "Tripadvisor::Models::AllLocations" do

  before(:each) do
    name = "Tokyo"
    uri = "http://www.tripadvisor.com/AllLocations-g1023181-c1-Hotels-Tokyo_Prefecture_Kanto.html"

    @obj = Tripadvisor::Models::AllLocations.new(name, uri)
  end

  describe "get_document" do
    it "class should be Nokogiri::HTML::Document" do
      result = @obj.get_document.class.to_s
      result.should == "Nokogiri::HTML::Document"
    end
  end

  describe "fetch_sub_locations" do
    it "# of sub-locations should be greater than 0" do
      doc = @obj.get_document
      @obj.fetch_sub_pages(doc)
      @obj.sub_locations.size.should > 0
      @obj.hotels.size.should        > 0
    end
  end

end
