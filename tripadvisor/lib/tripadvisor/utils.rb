module Tripadvisor
  module Utils


    ## デフォルトの言語
    DEFAULT_LANG  = :US

    ## 言語ごとの URI
    BASE_URI_I18N = {
        :US => "http://www.tripadvisor.com/",
        :JP => "http://www.tripadvisor.jp/"
      } 

    def base_uri(lang = DEFAULT_LANG) 
      BASE_URI_I18N[lang.to_sym]
    end

    def full_uri(uri, lang = DEFAULT_LANG)
      (uri =~ /^http/) ?  uri : base_uri(lang) + uri.gsub(/^(\/|\s*)/, "")
    end

  end
end
