require "rubygems"

require 'nokogiri'
require 'open-uri'

module TripAdvisor
  module Models
    module Page

      BASE_URI = 'http://www.tripadvisor.com/'

      def initialize(name, uri) 
        @name = name
        @uri  = URI.parse(uri) if uri.respond_to? :to_str
      end

      def get_document(uri = @uri)
        Nokogiri::HTML(open(uri))
      end

      def self.full_uri(uri)
        (uri =~ /^\//) ? BASE_URI + uri : uri
      end

      def self.factory(element)
        throw NotImplementationedException(__FILE__, __fund__, "")
      end

    end
  end
end

