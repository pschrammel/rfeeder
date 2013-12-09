# -*- encoding : utf-8 -*-
module PSchrammelUtils
  module Behaviourable
    def extend mod
      @ancestors ||= {}
      return if @ancestors[mod]
      mod_clone = mod.clone
      @ancestors[mod] = mod_clone
      super mod_clone
    end

    def remove mod
      mod_clone = @ancestors[mod]
      mod_clone.instance_methods.each do |m|
        mod_clone.module_eval do
          remove_method m
        end
      end
      @ancestors[mod] = nil
    end
    def undefine mod
      mod_clone = @ancestors[mod]
      mod_clone.instance_methods.each do |m|
        mod_clone.module_eval do
          undef_method m
        end
      end
      @ancestors[mod] = nil
    end
  end
end
