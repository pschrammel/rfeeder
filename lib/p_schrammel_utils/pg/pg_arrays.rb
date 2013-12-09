# -*- encoding : utf-8 -*-
module ActiveRecord
  module PgArrays
    def self.to_char_array(value,con)
      return 'NULL' if value.nil? || value.empty? || value =='{}'
      value=from_char_array(value) if value.kind_of?(String)
      raise "Don't know how to convert #{value.inspect} to PgArray" unless value.kind_of?(Array)
      "'" +con.quote_string("{#{value.map do |v| v.gsub(',',';') end.reject do |i|
        i.blank?
      end.uniq.join(',')}}") + "'"
    end

    def self.to_int_array(value,con)
      return 'NULL' if value.nil? || value.empty? || value =='{}'
      value=from_int_array(value) if value.kind_of?(String)
      raise "Don't know how to convert #{value.inspect} to PgArray" unless value.kind_of?(Array)

      "'" +con.quote_string("{#{value.compact.uniq.map(&:to_s).join(',')}}") + "'"
    end

    def self.from_char_array(value)
      if value.present?
        value[1..-2].split(',').map do |v|
          v=v[1..-2] if v[0]=='"'
          v
        end
      else
        nil
      end
    end

    def self.from_int_array(value)
      if value.present?
        if value.kind_of?(String)
          value=value[1..-2].split(',')
        end
        value.map(&:to_i)
      else
        nil
      end
    end
  end #PgArrays

  module ConnectionAdapters
    class PostgreSQLColumn < Column
      def type_cast_code_with_pg_arrays(var_name)
        #Rails.logger.debug "#{var_name},#{type}"
        case
          when type == :hstore
            "#{var_name}.from_hstore"
          when type == :string_array
            "ActiveRecord::PgArrays.from_char_array(#{var_name})"
          when type == :integer_array
            "ActiveRecord::PgArrays.from_int_array(#{var_name})"
          else
            type_cast_code_without_pg_arrays(var_name)
        end
      end

      alias_method_chain :type_cast_code, :pg_arrays

      def simplified_type_with_pg_arrays(field_type)

        ret=case
          when field_type =~ /^hstore$/
            :hstore
           when field_type =~ /^character varying\[\]$/
            :string_array
          when field_type =~ /^bigint\[\]$/
            :integer_array
          else
            simplified_type_without_pg_arrays(field_type)

            end
        ret
      end

      alias_method_chain :simplified_type, :pg_arrays
    end

    class PostgreSQLAdapter < AbstractAdapter
      def quote_with_pg_arrays(value, column=nil)
        case
          when value && column && column.type == :string_array
            ActiveRecord::PgArrays.to_char_array(value,self)
          when value && column && column.type == :integer_array
            ActiveRecord::PgArrays.to_int_array(value,self)
          when value && column && column.type == :hstore
            raise HstoreTypeMismatch, "#{column.name} must have a Hash or a valid hstore value (#{value})" unless value.kind_of?(Hash) || value.valid_hstore?
            return value.to_hstore
          else
            quote_without_pg_arrays(value, column)
        end
      end

      alias_method_chain :quote, :pg_arrays
    end
  end


  class Base
    def arel_attributes_values(include_primary_key = true, include_readonly_attributes = true, attribute_names = @attributes.keys)
      attrs = {}
      attribute_names.each do |name|
        if (column = column_for_attribute(name)) && (include_primary_key || !column.primary)
          if include_readonly_attributes || (!include_readonly_attributes && !self.class.readonly_attributes.include?(name))
            value = read_attribute(name)
            if value && ((self.class.serialized_attributes.has_key?(name) &&
                    (value.acts_like?(:date) || value.acts_like?(:time))) ||
                    value.is_a?(Hash) || value.is_a?(Array))
             # logger.debug(self.class.columns_hash[name].type.inspect)
              case

                when self.class.columns_hash[name].type == :string_array
                  ActiveRecord::PgArrays.to_char_array(value,connection)
                when self.class.columns_hash[name].type == :integer_array
                  ActiveRecord::PgArrays.to_int_array(value,connection)
                when self.class.columns_hash[name].type == :hstore
                  value = value.to_hstore # Done!

                else
                  value = value.to_yaml
              end
            end
            attrs[self.class.arel_table[name]] = value
          end
        end
      end
      attrs
    end

  end #Base
end #
