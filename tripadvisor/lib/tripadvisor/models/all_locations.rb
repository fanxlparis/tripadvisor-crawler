require "rubygems"
require 'pp'

require 'tripadvisor/utils'
require 'tripadvisor/models/page'
require 'tripadvisor/models/hotel'

module Tripadvisor
  module Models
    class AllLocations

      include Tripadvisor::Utils
      include TripAdvisor::Models::Page

      attr_reader :sub_locations, :hotels

      def initialize(*args)
        super(*args)
        @sub_locations = Array.new
        @hotels = Array.new
      end

      def fetch_sub_pages(doc)
        doc.css("div#BODYCON").css("a").each do |element|
          href_value = element.attribute("href").value
          # sub location page
          if href_value =~ /^\/(AllLocations|Hotels)/
            begin
              sub_location = factory(element)
              sub_location.parent_page = self
              @sub_locations << sub_location
              log.info("add #{sub_location.uri} as a sub_location at #{@uri}")
            rescue
              log.error("parsing error: #{element} at #{uri}")
            end
          end

          # hotel page
          if href_value =~ /^\/Hotel_Review/
            begin
              name = element.children[0].content.to_s
              uri = full_uri(element.attribute("href").value.to_s)
              unless Tripadvisor::Models::Hotel.is_fetched(uri)
                hotel = Tripadvisor::Models::Hotel.new(name, uri)
                hotel.parent_page = self
                @hotels << hotel
                log.info("add #{hotel.uri} as a hotel at #{@uri}")
              else
                log.warn("#{name}: #{uri} is already fetched")
              end
            rescue
              log.error("parsing error: #{element} at #{uri}")
            end
          end
        end
      end

      def factory(element)
        name = element.children[0].content
        uri = full_uri(element.attribute("href").value)
        Tripadvisor::Models::AllLocations.new(name, uri)
      end

    end
  end
end
