require "spec_helper"
require "tripadvisor"

describe Tripadvisor::Utils do
  include Tripadvisor::Utils

  describe "base_uri" do
    it "should be base URI for US language" do
      result = base_uri()
      expected = "http://www.tripadvisor.com/"
      result.should == expected
    end
  end

  describe "full_uri" do
    it "should be a URI which is attachec base URI" do
      result = full_uri("test")
      expected = "http://www.tripadvisor.com/test"
      result.should == expected
    end
  end
end
