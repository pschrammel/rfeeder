# -*- encoding : utf-8 -*-

module PSchrammelUtils
  module ModelStores
    class FileStore
      def initialize(options = {})
        @options=options.with_indifferent_access
        @prefix=options[:prefix] || ''
        @path = options[:path] || Rails.root.join('tmp','sessions').to_s
        @serializer = options[:serializer] || Marshal
        ensure_path
      end

      def [](key)
        fname = filename( key )
        content = {}
        if File.exists? fname
          begin
            content = @serializer.load( File.open( fname,'rb' ) )
          rescue => error
            Rails.logger.warn("could not load #{fname}: #{error.class} #{error.message}")
          end
        end
        content
      end

      def []=(key,value)
        fname = filename( key )
        content = @serializer.dump( value)
        # avoid changing the session if marshal dump fails
        File.open( fname, "wb" ) do | fh |
          fh.write content
          fh.flush
        end
        nil
      end

      def delete(key)
        FileUtils.rm_f(filename(key))
      end

      private
      def ensure_path
        FileUtils.mkdir_p(@path) unless File.exist?(@path)
      end
      
      def filename( key )
        File.join( @path,"#{@prefix}#{key}" )
      end
      
    end
  end
end
