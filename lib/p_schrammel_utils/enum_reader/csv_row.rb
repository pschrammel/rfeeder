# -*- encoding : utf-8 -*-
require 'csv'
require 'ostruct'

module PSchrammelUtils
  module EnumReader

    #read a csv file
    class CSVRow < OpenStruct

      def initialize(columns,row,nil_format)
        super()
        columns.each do |column|
          self.send("#{column.name}=",
            ColumnTypeConverter.convert(row[column.index],column.type,nil_format))
        end
      end

      def id
        @table[:id]
      end
      
      def id=(_id)
        @table[:id]=_id
      end
      
      def to_hash
        @table
      end
            
    end
  end
end
