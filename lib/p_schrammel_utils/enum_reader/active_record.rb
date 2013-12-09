# -*- encoding : utf-8 -*-

require 'csv'
require 'ostruct'

module PSchrammelUtils
  module EnumReader

    #read a csv file
    class ActiveRecord
      
      
      def initialize(options={})
        @model=options[:model]
        raise "no model class given" unless @model
      end
      
      attr_reader :model

      def all
        model.all
      end
      def find_by_id(id)
        model.find_by_id(id)
      end

      def delete(id)
        find_by_id(id).delete
      end

      def create(values)
        PSchrammelUtils::Fixture.create!(model,values)
      end

      def update(id,values_hash)
        find_by_id(id).update_attributes!(values_hash)
      end
    end
  end
end
