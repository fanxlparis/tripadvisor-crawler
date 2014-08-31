require "spec_helper"
require "tripadvisor"

describe Tripadvisor::Models::Hotel do

  before(:all) do
    name = "Business Hotel Emblem"
    uri = "http://www.tripadvisor.com/Hotel_Review-g1021286-d1045374-Reviews-Business_Hotel_Emblem-Yamato_Kanagawa_Prefecture_Kanto.html"

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
          :"street-address" => {:order => 0, :value => "1-6-3 Minamirinkan"},
          :locality         => {:order => 1, :value => "Yamato"},
          :region           => {:order => 2, :value => "Kanagawa Prefecture"},
          :"postal-code"    => {:order => 3, :value => "242-0006"},
          :"country-name"   => {:order => 4, :value => "Japan"}
        }
    end
  end

  it "get_span_format_address" do
    result = @obj.get_span_format_address
    result.class.to_s.should === "Nokogiri::XML::Element"
    result.to_s.should == "<span class=\"format_address\"><span class=\"street-address\" property=\"v:street-address\">1-6-3 Minamirinkan</span>, <span class=\"locality\"><span property=\"v:locality\">Yamato</span>, <span property=\"v:region\">Kanagawa Prefecture</span> <span property=\"v:postal-code\">242-0006</span></span>, <span class=\"country-name\" property=\"v:country-name\">Japan</span> </span>"
    result.content.should == "1-6-3 Minamirinkan, Yamato, Kanagawa Prefecture 242-0006, Japan "
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

end
