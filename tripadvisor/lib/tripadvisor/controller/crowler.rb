require "rubygems"
require "csv"
require "pp"

require 'tripadvisor/logging'
require 'tripadvisor/models/all_locations'
require 'tripadvisor/models/hotel'

module Tripadvisor
  module Controller
    class Crowler
      include Tripadvisor::Logging

      def run(options)
        ## read the csv file
        prefectures = CSV.read(options[:input]) 
        ## outpath
        outpath = options[:outpath]
        Dir::mkdir(outpath) unless Dir::exists?(outpath)
        ## output type
        outtype = (options[:type] == 'json') ? 'json' : 'csv'

        prefectures.each do |name, uri|
          file = open("#{outpath}/#{name}.#{outtype}", "w")

          locations = Tripadvisor::Models::AllLocations.new(name, uri)
          fetch_recursively(locations, file, outtype)

          file.close
        end
      end

      def fetch_recursively(locations, file, outtype)
          doc = locations.get_document
          locations.fetch_sub_pages(doc)

          locations.hotels.each do |hotel|
            begin
              hotel.fetch_content
              method = case outtype
                when 'json' then 'to_json'
                else 'to_csv'
              end
              out_line = hotel.send(method) 
              file.puts(out_line)
            rescue => e
              log.error(e)
            end
          end

          locations.sub_locations.each do |sub_location|
            fetch_recursively(sub_location, file, outtype)
          end
      end

    end
  end
end
