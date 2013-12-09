# -*- encoding : utf-8 -*-
module PSchrammelUtils
  module Setter
    def self.instance_var(obj,options)
      options.each do |attr,val|
        obj.instance_variable_set("@#{attr}",val)
      end
    end
  end
end
