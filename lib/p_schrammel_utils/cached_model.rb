# -*- encoding : utf-8 -*-
module PSchrammelUtils
  module CachedModel

    def self.included(base)
      base.extend ClassMethods
    end

    #extend ActiveRecrord::IdentityMap with this
    module PermanentIdentityMap
      def self.included(base)
        class << base

          def get(klass, primary_key)
            record = permanent_repository[klass.symbolized_sti_name][primary_key] ||
                repository[klass.symbolized_sti_name][primary_key]

            if record.is_a?(klass)
              ActiveSupport::Notifications.instrument("identity.active_record",
                                                      :line => "From Identity Map (id: #{primary_key})",
                                                      :name => "#{klass} Loaded",
                                                      :connection_id => object_id)

              record
            else
              nil
            end
          end

          def add(record)
            return record if configatron.identitymap_readonly
            repository[record.class.symbolized_sti_name][record.id] = record
          end

        end

        base.extend ClassMethods
      end

      module ClassMethods
        def permanent_repository
          @permanent_repository ||= Hash.new { |h, k| h[k] = {} }
        end

        def permanent_add(record)
          permanent_repository[record.class.symbolized_sti_name][record.id] = record
        end

      end
    end
    module ClassMethods
      #:order  order of items in cached_all (default: 'id')
      #:hashed list of attributes to provide hashes for (default: [ 'id'];
      #        id will always be added to that list, if missing
      #:constantize  attribute to provide constants for (default: 'iname')
      #            use nil, not to generate constants
      def cache_model(options = {})
        @cache_model ||= Cache.new(self, options).reload
      rescue ActiveRecord::StatementInvalid => error
        Rails.logger.error "Couldn't Cache Model: #{self.name}"
      end


    end


    class Cache

      def initialize(klass, options)
        defaults = {
            :order => 'id',
            :hashed => ['id'],
            :constantize => 'iname',
            :methods => false
        }
        raise "unexpected options #{(options.keys - defaults.keys).inspect},
 allowed options are #{defaults.keys.inspect}" unless (options.keys - defaults.keys).empty?

        @options = defaults.merge(options)
        @options[:hashed] = @options[:hashed].map(&:to_s)
        @options[:hashed] << 'id' unless @options[:hashed].include? 'id'
        @state =:unloaded
        @klass =klass
        @hashes= Hash.new do |hash, key|
          hash[key]=Hash.new
        end
        @all =[]
      end

      def reload
        load(true)
        self
      end

      def loaded?
        @state == :loaded
      end

      def loading?
        @state == :loading
      end

      private
      def load(force=false)
        return nil if (loaded? && !force) || loading?
        @state=:loading

        cache_all
        cache_by_attribute
        def_constants
        def_methods
        def_find_by
        add_to_identitymap

        @state=:loaded
        nil
      end

      def cache_all
        @all = @klass.order(@options[:order]).all.freeze
      end

      def cache_by_attribute
        @all.each do |entry|
          @options[:hashed].each do |att|
            @hashes[att][entry.send(att)] = entry
          end
        end
      end

      def def_find_by
        hashes=@hashes
        @options[:hashed].each do |att|
          @klass.singleton_class.__send__(:define_method, "find_by_#{att}") do |key|
            hashes[att][key]
          end
        end
      end

      def def_constants
        if @options[:constantize]
          @all.each do |model|
            name = model.send(@options[:constantize]).upcase
            @klass.const_set name, model
          end
        end
      end

      def def_methods
        if @options[:methods]
          @all.each do |model|
            the_iname_value=model.send(@options[:constantize])
            @klass.__send__(:define_method, "#{the_iname_value}?") do
              self.iname==the_iname_value
            end
          end
        end
      end


      def add_to_identitymap
        @all.each do |obj|
          ActiveRecord::IdentityMap.permanent_add(obj)
        end
      end
    end #Cache
  end #CachedModel
end

