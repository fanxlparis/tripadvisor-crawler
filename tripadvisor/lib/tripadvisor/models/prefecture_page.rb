require "rubygems"

require 'net/http'
require 'uri'

require 'nokogiri'
require 'open-uri'

module Tripadvisor
  module Models
    class PrefecturePage

      def initialize(name, uri) 
        @name = name
        @uri  = URI.parse(uri) if uri.respond_to? :to_str
      end

      def get_document(uri = @uri)
        @doc = Nokogiri::HTML(open(uri))
      end

      def get_lodging_links(doc = @doc)
        ## div#BODYCON 以下のリンクの中で
        ## Ldging in XXX になっているリンクを取得
        links = Array.new
        doc.css("div#BODYCON").css("a").each do |link|
          if link.content =~ /^Lodging in/
            links << link
          end
        end
        return links
      end
    end
  end
end
