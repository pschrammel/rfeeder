# -*- encoding : utf-8 -*-
module PSchrammelUtils
  module Interpolator
    def self.interpolate(pattern, subs)
      subs.keys.inject(pattern) do |result, tag|
        result.gsub(/:#{tag}/) do |match|
          subs[tag]
        end
      end
    end
  end
end
