require "spec_helper"
require "tripadvisor"

class Dummy
  include Tripadvisor::Logging
end

class Dummy2
  include Tripadvisor::Logging
end

describe Tripadvisor::Logging do
  
  before(:all) do
    @dummy = Dummy.new
    @dummy2 = Dummy2.new
  end

  it "can show warn message" do
    @dummy.log.warn('hoge')
  end

  it "can show error message" do
    @dummy.log.error('hoge')
  end

  it "can configure the log level" do
    @dummy.log.should === @dummy2.log
  end

end
