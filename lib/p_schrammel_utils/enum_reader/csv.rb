# -*- encoding : utf-8 -*-
require 'csv'
require 'ostruct'

module PSchrammelUtils
  module EnumReader

    #read a csv file
    class CSV 

      
      def initialize(options={})
        @filename=options[:filename]
        raise "no filename given" unless @filename
        @options={:nil_format => '--',:primary => :id, :primary_type => :integer}.merge(options)

        #begin
        puts "Reading #{@filename}" unless Rails.env.test?
        reader=::CSV.open(@filename,"r")
        read_meta(reader)
        read_data(reader)
        #rescue
        #  raise
        #ensure
        reader.close if reader
        #end
        self
      end
      attr_reader:filename,:columns,:all,:all_by_id

      def find_by_id(_id)
        return @all_by_id[_id] if @all_by_id
        @all_by_id=all.index_by(&:id).with_indifferent_access
        @all_by_id[_id]
      end

      private
            
      def read_meta(reader)
        row = reader.shift
        raise ReaderError.new("no column definitions") if row.empty?

        @columns=[]
        index=0
        row.each do |name_type|
          name,type=name_type.split(':')
          @columns << Column.new(name,type,:index => index)
          index += 1
        end
      end

      def read_data(reader)
        data=[]
        while true
          row = reader.shift
          break if row.nil? || row.compact.empty?
          row_data = CSVRow.new(columns,row,@options[:nil_format])
          data << row_data if row_data.id
        end
        @all=data
      end
    end
  end
  
end
