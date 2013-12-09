# -*- encoding : utf-8 -*-
#use this with ActiveRecord::Migration.extend(PSchrammelUtils::PG::MigrationHelpers)
module PSchrammelUtils
  module PG
    module MigrationHelpers

      #grant :users,:maxi,%w(SELECT UPDATE)
      def grant(table_name, user, rights)
        execute %(GRANT #{rights.join(", ")} ON #{table_name} TO #{user})
      end

      
      def drop_private_key(table_name)
        execute %(ALTER TABLE #{table_name} DROP CONSTRAINT #{table_name}_pkey)
      end

      def add_private_key(table_name,options={})
        tablespace=(options[:tablespace] ? " TABLESPACE #{options[:tablespace]}" : '')
        execute %(ALTER TABLE #{table_name} ADD PRIMARY KEY ( id ))
      end

      def add_foreign_key(from_table, from_column, to_table)
        unless Rails.env.test?
          execute %(ALTER TABLE #{from_table}
              ADD CONSTRAINT #{constraint_name(from_table, from_column)}
              FOREIGN KEY (#{from_column})
              REFERENCES #{to_table}(id) DEFERRABLE)
        end
      end

      def drop_foreign_key(from_table, from_column)
        execute %(ALTER TABLE #{from_table}
            DROP CONSTRAINT #{constraint_name(from_table, from_column)})
      end


      def indices(table, schema = 'public' )
        ActiveRecord::Base.connection.select_all("
              SELECT c2.relname as name,
                     i.indisprimary as primary,
                     pg_catalog.pg_get_indexdef(i.indexrelid, 0, true) as definition,
                     t.spcname as tablespace
              FROM pg_catalog.pg_class c
              join pg_namespace n on c.relnamespace = n.oid
              join pg_catalog.pg_index i on c.oid = i.indrelid
              join pg_catalog.pg_class c2 on i.indexrelid = c2.oid
              join pg_catalog.pg_tablespace t on c2.reltablespace = t.oid
              WHERE c.relname = '#{table}' and  n.nspname = '#{schema}'
              ORDER BY i.indisprimary DESC, i.indisunique DESC, c2.relname
          ")
      end

      def drop_indices( table, schema = 'public' )
        idx=indices(table,schema)
        idx.each do | index |
          next if index['primary'] == 't' # no pk handling ATM
          drop_index index['name']
        end
        idx
      end
    
      def recreate_indices(indices,options={})
        indices.each do | index |
          next if index['primary'] == 't' # no pk handling ATM
          create_stmt = if index['definition'] =~ /where/i
            index['definition'].sub(/\bwhere\b/i, "tablespace \"#{index['tablespace']}\" where")
          else
            "#{index['definition']} tablespace \"#{index['tablespace']}\""
          end
          ActiveRecord::Baseconnection.execute( create_stmt )
        end
      end

      def without_indices( table, schema = 'public' )
        ActiveRecord::Base.transaction do
          indices = drop_indices( table, schema )
          yield
          recreate_indices( indices )
        end
      end

      private
      def sequence_from_tablename(table_name)
        "#{table_name}_id_seq"
      end

      def constraint_name(table, column)
        "fk_#{table}_#{column}"
      end


    end
  end
end
