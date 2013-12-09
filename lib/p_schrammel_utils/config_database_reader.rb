# -*- encoding : utf-8 -*-
require 'yaml'
require 'erb'
require 'pg'

module PSchrammelUtils

  class ConfigDatabaseReader
    class NoSuchEnvironment < StandardError; end

    def initialize(config_filename,environment)
      @config_filename=config_filename
      @environment = environment
      hash
    end
    attr_reader :config_filename
    attr_reader :environment
    def content
      @content ||= ERB.new(IO.read(config_filename), nil, '-').result(binding)
    end

    def hash
      return @hash if @hash
      parsed = YAML.load( content )
      raise NoSuchEnvironment.new(@environment) unless parsed[@environment]
      @hash=parsed[@environment]
    end

    def connection
      PGconn.connect( hash['host'], hash['port'] || 5432, "", "",
        hash['database'],
        hash['username'],
        hash['password'] )
    end
  end
end
