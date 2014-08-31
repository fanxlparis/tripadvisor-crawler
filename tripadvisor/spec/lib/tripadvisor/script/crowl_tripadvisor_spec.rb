require "spec_helper"
require "tripadvisor"

describe Tripadvisor::Script::CrowlTripadvisor do

  describe "execute" do
    it "can start" do
      args = [
        'execute',
        '--input', "#{$ROOT_PATH}/resources/prefecture-urls.csv",
      ]
      Tripadvisor::Script::CrowlTripadvisor.start(args)
    end
  end
end
