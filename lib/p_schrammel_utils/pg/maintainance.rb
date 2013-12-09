module PSchrammelUtils
  module Pg
    class Maintainance
      def initialize(environment, db_config, options={})
        @environment=environment

        @db_config=db_config
        @dump_file = options[:dump] || 'dump.sql'
        @error_file = options[:logfile] || "db_errors.log"
        @passphrase = options[:passphrase]
        @encrypt= !!@passphrase
      end

      def dump
        dbconfig=PSchrammelUtils::ConfigDatabaseReader.new(@db_config, @environment)
        if @encrypt
          outputter = " | gpg --passphrase \"#{@passphrase}\" -c  > #{@dump_file} "
        else
          outputter = " -f #{@dump_file} "
        end
        cmd="PGPASSWORD=#{dbconfig.hash['password']} pg_dump -E 'utf8'  -F c -h #{dbconfig.hash['host']} -p #{dbconfig.hash['port'] || 5432} -U #{dbconfig.hash['username']} -w #{dbconfig.hash['database']} 2>#{@error_file} #{outputter} "
        execute cmd
      end

      def restore
        dbconfig=PSchrammelUtils::ConfigDatabaseReader.new(@db_config, 'development')
        if @encrypt
          inputter = "cat #{@dump_file} | gpg --passphrase \"#{@passphrase}\" -d  | "
        else
          inputter = "cat #{@dump_file} | "
        end
        cmd="PGPASSWORD=#{dbconfig.hash['password']} createdb -E utf8 -h #{dbconfig.hash['host']} -p #{dbconfig.hash['port'] || 5432} -U #{dbconfig.hash['username']} -w #{dbconfig.hash['database']} 2>#{@error_file}"
        execute cmd
        cmd="#{inputter} PGPASSWORD=#{dbconfig.hash['password']} pg_restore -d #{dbconfig.hash['database']} -U #{dbconfig.hash['username']} -h #{dbconfig.hash['host']} -p #{dbconfig.hash['port'] || 5432} -w 2>#{@error_file}"
        execute cmd
      end

      def execute(cmd)
        puts "executing: #{cmd}"
        Kernel.system cmd
      end
    end
  end
end