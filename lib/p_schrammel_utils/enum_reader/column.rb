# -*- encoding : utf-8 -*-
require 'ostruct'
module PSchrammelUtils
  module EnumReader
    class Column < OpenStruct
      class NoSuchType < StandardError; end
      TYPES=[:integer,:string,:boolean,:date,:float]

      attr_reader :type
      def initialize(name,type,options={}) 
        raise NoSuchType.new(type.inspect) if type.nil? || !TYPES.include?(type.to_sym)
        super(options)
        self.name = name.to_sym
        @type= type.to_sym
      end
      
      
    end
  end
end
