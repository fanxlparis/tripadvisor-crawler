require "spec_helper"
require "tripadvisor"

describe Tripadvisor::Models::Hotel do

  before(:all) do
    name = "Business Hotel Emblem"
    #uri = "http://www.tripadvisor.com/Hotel_Review-g1021286-d1045374-Reviews-Business_Hotel_Emblem-Yamato_Kanagawa_Prefecture_Kanto.html"
    uri = "http://www.tripadvisor.com/Hotel_Review-g1066443-d302435-Reviews-Imperial_Hotel_Tokyo-Chiyoda_Tokyo_Tokyo_Prefecture_Kanto.html"

    @obj = Tripadvisor::Models::Hotel.new(name, uri)
    @obj.fetch_content
  end

  describe "fetch_content" do
    it "can fetch the content" do
      @obj.content.class.to_s.should == "Nokogiri::HTML::Document"
    end
  end

  describe "extract_address" do
    it "can extract address" do
      result = @obj.extract_address
      result.class.to_s.should == "Hash"
      result.should == {
          :"street-address" => {:order => 0, :value => "1-1-1 Uchisaiwaicho"},
          :locality         => {:order => 1, :value => "Chiyoda"},
          :region           => {:order => 2, :value => "Tokyo Prefecture"},
          :"postal-code"    => {:order => 3, :value => "100-8558"},
          :"country-name"   => {:order => 4, :value => "Japan"}
        } 
    end
  end

  it "get_span_format_address" do
    result = @obj.get_span_format_address
    result.class.to_s.should === "Nokogiri::XML::Element"
    result.to_s.should == "<span class=\"format_address\"><span class=\"street-address\" property=\"v:street-address\">1-1-1 Uchisaiwaicho</span>, <span class=\"locality\"><span property=\"v:locality\">Chiyoda</span>, <span property=\"v:region\">Tokyo Prefecture</span> <span property=\"v:postal-code\">100-8558</span></span>, <span class=\"country-name\" property=\"v:country-name\">Japan</span> </span>"
    result.content.should == "1-1-1 Uchisaiwaicho, Chiyoda, Tokyo Prefecture 100-8558, Japan "
  end

  describe "get_address_elements" do
    it "should be expected" do
      result = @obj.get_address_elements
      result.class.to_s.should == "Array"
      result.length.should == 5
      result.each{|node| node.class.to_s.should == "Nokogiri::XML::Element"}

      contents = result.map {|node| node.content}
      contents.should == [
          "1-1-1 Uchisaiwaicho", "Chiyoda", "Tokyo Prefecture",
          "100-8558", "Japan"
        ]
    end
  end

  describe "get_address_element_types" do
    it "should be expected" do
      result = @obj.get_address_element_types
      result.should == [
          "v:street-address" , "v:locality"      , "v:region" , 
          "v:postal-code"    , "v:country-name"
        ]
    end
  end

  describe "extract_price_range" do
    it "can extract the price range" do
      result = @obj.extract_price_range
      result.should == "$$$$"
    end
  end

  describe "extract_num_rooms" do
    it "can extract the number of rooms" do
      result = @obj.extract_num_rooms
      result.should == 931
    end
  end

end
