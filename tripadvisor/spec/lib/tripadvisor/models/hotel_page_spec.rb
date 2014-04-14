require "spec_helper"
require "tripadvisor"

describe Tripadvisor::Models::HotelPage do
  before(:each) do
    name = "Business Hotel Emblem"
    uri = "http://www.tripadvisor.com/Hotel_Review-g1021286-d1045374-Reviews-Business_Hotel_Emblem-Yamato_Kanagawa_Prefecture_Kanto.html"

    @obj = Tripadvisor::Models::HotelPage.new(name, uri)
  end

  describe "get_span_format_address" do
    it "should be span.format_address" do
      result = @obj.get_span_format_address()
      result.class.to_s.should == "Nokogiri::XML::Element"
      result.to_s.should == "<span class=\"format_address\"><span class=\"street-address\" property=\"v:street-address\">1-6-3 Minamirinkan</span>, <span class=\"locality\"><span property=\"v:locality\">Yamato</span>, <span property=\"v:region\">Kanagawa Prefecture</span> <span property=\"v:postal-code\">242-0006</span></span>, <span class=\"country-name\" property=\"v:country-name\">Japan</span> </span>"
      result.content.should == "1-6-3 Minamirinkan, Yamato, Kanagawa Prefecture 242-0006, Japan "
    end
  end

  describe "get_address_elements" do
    it "should be expected" do
      result = @obj.get_address_elements
      result.class.to_s.should == "Array"
      result.length.should == 5
      result.each{|node| node.class.to_s.should == "Nokogiri::XML::Element"}

      contents = result.map {|node| node.content}
      contents.should == [
          "1-6-3 Minamirinkan" , "Yamato" , "Kanagawa Prefecture" , 
          "242-0006"           , "Japan"
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

  describe "validate_address_element_types" do
    it "shuld be true" do
      result = @obj.validate_address_element_types
      result.should == true
    end
  end

end
