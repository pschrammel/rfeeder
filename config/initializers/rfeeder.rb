require 'p_schrammel_utils/pg/migration_helpers'
ActiveRecord::Migration.extend(PSchrammelUtils::PG::MigrationHelpers)
ActiveRecord::Migration.send(:include,PSchrammelUtils::PG::MigrationHelpers)


