module Tripadvisor
  ## 言語ごとの URI
  BASE_URI_I18N = {
      :US => "http://www.tripadvisor.com/",
      :JP => "http://www.tripadvisor.jp/"
    } 

  ## デフォルトの言語
  DEFAULT_LANG  = :US
  ## デフォルトの URI
  DEFAULT_BASE_URI = BASE_URI_I18N[DEFAULT_LANG]
end
