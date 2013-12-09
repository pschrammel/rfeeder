# -*- encoding : utf-8 -*-
require 'memcache'
module PSchrammelUtils
  module ModelStores
    class MemCache
      def initialize(options = {})
        @options=options.with_indifferent_access
        @prefix=options[:prefix] || ''
        @namespace=options[:namespace] || 'rails'
        @server = options[:server] || "localhost:11211"
        @connection=::MemCache.new(@server,:namespace => @namespace)
      end

      def [](key)
        @connection[prefixed_key(key)] || HashWithIndifferentAccess.new
      end

      def []=(key,value)
        @connection[prefixed_key(key)]=value
        nil
      end

      def delete(key)
        @connection.delete(prefixed_key(key))
      end

      private
      def prefixed_key(key)
        "#{@prefix}#{key}"
      end
    end
  end
end
