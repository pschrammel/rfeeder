# -*- encoding : utf-8 -*-
require 'date'
module PSchrammelUtils
  module EnumReader
    module ColumnTypeConverter
      def self.convert(value,type,nil_value)
        return nil if value==nil_value
        case type
        when :string
          return value.to_s.strip
        when :integer
          return value.to_i
        when :boolean
          return true if ["true",true,"t","1"].include?(value)
          return false
        when :date
          return Date.parse(value)
        when :float
          return value.to_f
        else
          raise "no such type converter #{type}"
        end
      end
    end
  end
end
