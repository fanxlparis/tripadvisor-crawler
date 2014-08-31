require "rubygems"
require 'pp'

require 'tripadvisor/utils'
require 'tripadvisor/models/page'

module Tripadvisor
  module Models
    class Hotel

      include Tripadvisor::Utils
      include TripAdvisor::Models::Page

      attr_reader :content
      attr_reader :address

      def initialize(name, uri)
        super(name, uri)
      end

      def factory(element)
        name = element.children[0].content
        uri = full_uri(element.attribute("href").value)
        Tripadvisor::Models::Hotel.new(name, uri)
      end

      def fetch_content
        @content = get_document(@uri)
      end

      def extract_address
        keys = convert_address_types(get_address_element_types)
        values = get_address_elements.map {|node| node.content}

        hash = Hash.new
        keys.zip(values).each_with_index {|(k, v), i| 
            hash[k.to_sym] = {:order => i, :value => v.to_s}
          }
        hash
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

      ## 住所の span 要素をすべて取得
      def get_span_format_address
        span_class = "span.format_address"
        @content.css(span_class).first
      end

      ## CSS クラスの 'v:xxxxxxx' のような余分なものを除去
      def convert_address_types(array)
        array.map{|type| type.to_s.gsub(/^v\:/, "")}.map{|type| type.to_sym}
      end

      ## 価格帯を抽出
      def extract_price_range
        get_price_range.content.to_s.gsub(/\n/, "")
      end

      ## 価格帯を取得
      def get_price_range
        price_range_element = nil
        div_class = "div.additional_info"
        @content.css(div_class).each do |div|
          price_range_element = div.css("span").select do |elm|
            elm.has_attribute?("property") &&
                elm.get_attribute("property") == "v:pricerange"
          end
        end
        price_range_element.first
      end

    end
  end
end
