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

      @@hashs = Array.new

      def initialize(name, uri)
        super(name, uri)
        @sub_locations = Array.new
        @hotels = Array.new
        add_hash(uri)
      end

      def fetch_sub_pages(doc)
        fetch_sub_locations(doc)
        fetch_sub_hotels(doc) if @sub_locations.length == 0
      end

      def fetch_sub_locations(doc)
        doc.css("div#BODYCON").css("table").css("a").each do |element|
          next if element.nil? || element.attribute("href").nil?
          href_value = element.attribute("href").value
          # sub location page
          if href_value =~ /^\/(AllLocations|Hotels)/ && href_value !~ /\-Restaurants\-/
            begin
              name = element.children[0].content.to_s
              uri = full_uri(element.attribute("href").value.to_s)
              log.info("add a sub_location: #{uri} at #{@uri}")
              unless self.class.is_fetched(uri)
                sub_location = factory(element)
                sub_location.parent_page = self
                @sub_locations << sub_location
              else
                log.warn("#{name}: #{uri} is already fetched ")
              end
            rescue => e
              log.error("parsing error: #{element} at #{uri} #{e.message}")
            end
          end
        end
      end

      def fetch_sub_hotels(doc)
        doc.css("div#BODYCON").css("table").css("a").each do |element|
          next if element.nil? || element.attribute("href").nil?
          href_value = element.attribute("href").value
          # hotel page
          if href_value =~ /^\/Hotel_Review/
            begin
              name = element.children[0].content.to_s
              uri = full_uri(element.attribute("href").value.to_s)
              uri.gsub!(/#[A-Z]+$/, "")
              log.info("add a hotel: #{uri} at #{@uri}")
              unless Tripadvisor::Models::Hotel.is_fetched(uri)
                hotel = Tripadvisor::Models::Hotel.new(name, uri)
                hotel.parent_page = self
                @hotels << hotel
              else
                log.warn("#{name}: #{uri} is already fetched")
              end
            rescue => e
              log.error("parsing error: #{element} at #{uri} #{e.message}")
            end
          end
        end
      end

      def factory(element)
        name = element.children[0].content
        uri = full_uri(element.attribute("href").value)
        Tripadvisor::Models::AllLocations.new(name, uri)
      end

      def add_hash(uri)
        hash = (uri =~ /^http/) ? Digest::MD5.hexdigest(uri) : uri
        @@hashs << hash
      end

      def self.is_fetched(uri)
        hash = (uri =~ /^http/) ? Digest::MD5.hexdigest(uri) : uri
        @@hashs.include?(hash)
      end

    end
  end
end
