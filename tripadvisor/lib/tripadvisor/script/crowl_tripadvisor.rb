require "rubygems"
require "thor"
require "csv"
require "pp"

require 'tripadvisor/controller/crowler'

module Tripadvisor
  module Script
    class CrowlTripadvisor < Thor
      default_command :execute

      desc 'execute [options]', 'run crowler'
      method_option :input,
        :aliases  => '-o',
        :type     => :string,
        :desc     => 'input a csv file path',
        :required => true
      method_option :outpath,
        :aliases  => '-o',
        :type     => :string,
        :default  => "crowl_tripadvisor.out",
        :desc     => 'output file path'
      method_option :type,
        :aliases  => '-t',
        :type     => :string,
        :default  => 'csv',
        :desc     => 'output type(json or csv)'
      method_option :sleep,
        :aliases  => '-s',
        :type     => :numeric,
        :default  => 5,
        :desc     => 'interval time until next fetching'
      method_option :verbose,
        :aliases  => '-v',
        :type     => :boolean,
        :default  => false,
        :desc     => 'verbose mode'
      def execute
        controller = Tripadvisor::Controller::Crowler.new
        controller.run(options)
      end

    end
  end
end
