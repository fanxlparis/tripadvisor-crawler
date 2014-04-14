require "rubygems"

require 'nokogiri'
require 'open-uri'

module Tripadvisor
  module Models
    class HotelPage 

      def initialize(name, uri) 
        @name = name
        @uri  = URI.parse(uri) if uri.respond_to? :to_str
        @doc  = get_document(@uri)
      end

      def get_document(uri)
        @doc = Nokogiri::HTML(open(uri))
      end

      ## 住所の span 要素をすべて取得
      def get_span_format_address
        span_class = "span.format_address"
        @doc.css(span_class).first
      end

      ## 住所のテキストを含む要素を取得
      def get_address_elements
        get_span_format_address.css("span").select do |elm|
          ## 住所の span 要素には property 属性を持つ
          elm.has_attribute?("property")
        end
      end

      ## 住所要素を取得
      def get_address_element_types
        get_address_elements.map {|elm| elm.get_attribute("property")}
      end

      ## 住所要素の検証
      def validate_address_element_types
        address_element_properties = [
           "v:street-address" , "v:locality"      , "v:region" , 
           "v:postal-code"    , "v:country-name"
         ]
        address_element_properties.each do |property|
          return false unless get_address_element_types.any?{|elm| elm == property}
        end
        return true
      end

    end
  end
end
