# -*- encoding : utf-8 -*-
# this class behaves like a fixture (at least you can use it with
# a connection's insert fixture

module PSchrammelUtils
  class Fixture
    #hash of attributes and the table name from model#table_name
    attr_reader :model,:attr

    def self.create!(model,attr)
      new(model,attr).insert!
    end
    
    def initialize(model,attr)
      @model=model
      @attr=HashWithIndifferentAccess.new(attr)
#      @keys=@attr.keys.dup
    end

#    def key_list
#      columns = @keys.collect{ |column_name| model.connection.quote_column_name(column_name) }
#      columns.join(", ")
#    end

#    def value_list
#      list = @keys.inject([]) do |values,key|
#        value=@attr[key]
#        col = model.columns_hash[key] if model.class.respond_to?(:ancestors) && model.ancestors.include?(ActiveRecord::Base)
#        values << model.connection.quote(value, col).gsub('[^\]\\n', "\n").gsub('[^\]\\r', "\r")
#      end
#      list * ', '
#    end

    def insert!
      #puts "inserting: #{@attr.inspect} into #{model.table_name}"
      model.connection.insert_fixture(self,model.table_name)
    end
    
    def map
      values=[]
      @attr.each_pair do |key,value|
        values << yield(key, value)
      end
      values
    end
  end
  
end
