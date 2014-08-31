require "rubygems"
require 'pp'

require 'tripadvisor/utils'
require 'tripadvisor/models/page'

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
          if href_value =~ /^\/AllLocations/
            @sub_locations << factory(element)
          end
          @hotels << element if href_value =~ /^\/Hotel/
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
