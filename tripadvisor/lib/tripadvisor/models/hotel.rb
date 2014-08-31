require "rubygems"
require 'json'
require 'pp'
require 'digest/md5'

require 'tripadvisor/utils'
require 'tripadvisor/models/page'

module Tripadvisor
  module Models
    class Hotel

      include Tripadvisor::Utils
      include TripAdvisor::Models::Page

      attr_reader :content, :address, :price_range, :num_rooms

      @@hashs = Array.new

      def initialize(name, uri)
        super(name, uri)
        add_hash(uri)
      end

      def factory(element)
        name = element.children[0].content
        uri = full_uri(element.attribute("href").value)
        Tripadvisor::Models::Hotel.new(name, uri)
      end

      def fetch_content
        @content = get_document(@uri) if @content.nil?
        @address     = extract_address
        @price_range = extract_price_range
        @num_rooms   = extract_num_rooms
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

      ## 客室数を抽出
      def extract_num_rooms 
        num_rooms = nil
        @content.css("div.tabs_num_rooms").each do |div|
          num_rooms = div.content.to_i if div.content =~ /^[0-9]+$/
        end
        num_rooms
      end

      ## 価格帯を抽出
      def extract_price_range
        (get_price_range.nil?) ?
          nil :
          get_price_range.content.to_s.gsub(/\n/, "")
      end

      ## 価格帯を取得
      def get_price_range
        price_range_element = nil
        div_class = "div.additional_info"
        @content.css(div_class).each do |div|
          div.css("span").each do |elm|
            if elm.has_attribute?("property") &&
                  elm.get_attribute("property") == "v:pricerange"
              price_range_element = elm
            end
          end
        end
        price_range_element
      end

      ## convert into JSON
      def to_json
        hash = {:name => @name, :uri => @uri}
        hash[:postal_code] = @address[:"postal-code"][:value]
        hash[:region]      = @address[:region][:value]
        hash[:address]     = address2string
        hash[:num_rooms]   = @num_rooms unless @num_rooms.nil?
        hash[:price_range] = @price_range unless @price_range.nil?
        hash.to_json
      end

      ## convert into CSV
      ## uri, postal_code, region, address, num_rooms, price_range
      def to_csv
        values = [
            @name,
            @address[:"postal-code"][:value],
            @address[:region][:value],
            address2string
          ]
        values << (@num_rooms.nil?) ? "NA" : @num_rooms
        values << (@price_range.nil?) ? "NA" : @price_range
        values << @uri
        values.to_csv.gsub!(/(\r|\n)/, "") 
      end

      ## convert the address hash into a joined string
      def address2string
        @address.select{|k,v|
            k != :"postal-code" && k != :region && k != :"country-name"
          }
          .sort{|(k1,v1), (k2,v2)| 
            v1[:order] <=> v2[:order]
          }.map {|array| array[1][:value]}.join(" ")
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
