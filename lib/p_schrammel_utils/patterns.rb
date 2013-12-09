# -*- encoding : utf-8 -*-
module PSchrammelUtils
  module Patterns
    HTTP_URL = /^(http|https):\/\/(((\d{1,3}\.){3}\d{1,3})|([a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}))((:[0-9]{1,5})?\/.*)?$/ix
  end
end
