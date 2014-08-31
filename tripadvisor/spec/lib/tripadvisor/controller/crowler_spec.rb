require "spec_helper"
require "tripadvisor"

describe Tripadvisor::Controller::Crowler do

  describe "run" do
    options = {
        :input => "#{$ROOT_PATH}/spec/resources/prefecture-urls.csv",
        :outpath => "#{$ROOT_PATH}/spec/tmp"
      }

    controller = Tripadvisor::Controller::Crowler.new
    controller.run(options)
  end
end
