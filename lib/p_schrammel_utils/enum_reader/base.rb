# -*- encoding : utf-8 -*-
module PSchrammelUtils
  module EnumReader
    class Base
      class ReadeError < StandardError;end

      def initialize(mapping)
        @name = mapping.name
        @source=mapping.source
        @destination=mapping.destination
      end

      attr_reader :source,:destination,:name
      
      def diff
        source_ids=source.all.map(&:id)
        destination_ids=destination.all.map(&:id)
        new_ids=source_ids-destination_ids
        deleted_ids = destination_ids - source_ids
        
        changed_ids={}
        common_ids = source_ids - new_ids - deleted_ids
        common_ids.each do |id|
          diff=column_diff(id)
          changed_ids[id]=diff unless diff.empty?
        end
        OpenStruct.new(:to_delete => deleted_ids,
          :to_create => new_ids,
          :to_change => changed_ids)
      end

      def update
        _diff=diff
        log_diff(diff)
        _diff.to_delete.each do |_id|  destination.delete(_id) end
        _diff.to_create.each do |_id|  destination.create(source.find_by_id(_id).to_hash) end
        _diff.to_change.each_pair do |_id,values_diff|
          new_values = HashWithIndifferentAccess.new
          values_diff.each_pair do |name,source_destination|
            new_values[name]=source_destination.first
          end
          destination.update(_id,new_values)
        end
        _diff
      end
      
      private
      def column_diff(id)
        diff={}
        source_row=source.find_by_id(id)
        destination_row=destination.find_by_id(id)
        source.columns.each do |column|
          source_value=source_row.send(column.name)
          destination_value = destination_row.send(column.name)
          diff[column.name.to_sym]=[source_value,destination_value] if source_value != destination_value
        end
        return diff
      end
     
     def log_diff(diff)
       puts "#{name.ljust(25)}:  #{diff.to_create.size.to_s.rjust(6)} | #{diff.to_change.size.to_s.rjust(6)} | #{diff.to_delete.size.to_s.rjust(6)}"
     end
     
      
    end
  end
end
