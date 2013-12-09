# -*- encoding : utf-8 -*-
module PSchrammelUtils
  module EnumReader
    class Config
      def self.create
        config=new
        yield config
        @@current=config
      end

      cattr_reader :current

      def self.diff
        current.diff
      end

      def self.update
        current.update
      end

      def initialize
        @resources=HashWithIndifferentAccess.new
        @maps=[]
      end
      attr_reader :resources,:maps

      def resource(name,type,options)
        resources[name]="PSchrammelUtils::EnumReader::#{type}".constantize.new(options)
      end

      def map(name, source, destination)
        @maps << OpenStruct.new(:name => name, :source => source,
                                :destination => destination)
      end

      def add(name,filename,model)
        csv=resource("csv_#{name}".to_sym,'CSV',:filename => filename)
        ar=resource("ar_#{name}".to_sym,'ActiveRecord',:model => model)
        map(name,csv,ar)
      end

      def diff
        diffs=[]
        @maps.each do |mapping|
          base=PSchrammelUtils::EnumReader::Base.new(mapping)
          diffs << base.diff
        end
        diffs
      end

      def update
        diffs=[]
        puts "#{'Name'.ljust(25)}:  INSERT | UPDATE | DELETE"
        @maps.each do |mapping|
          raise "Something's wrong with source" unless mapping.source
          raise "Something's wrong with destination" unless mapping.destination
          base=PSchrammelUtils::EnumReader::Base.new(mapping)
          diffs << base.update
        end
        diffs
      end


    end
  end
end
