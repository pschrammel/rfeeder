# -*- encoding : utf-8 -*-
module PSchrammelUtils
  # Stolen from    https://github.com/iain/http_accept_language

  class HttpAcceptLanguageParser
    #accept is request['HTTP_ACCEPT_LANGUAGE.'] something like "de-de,de;q=0.8,en;q=0.5,hu;q=0.3"
    def initialize(accept)
      @accept=accept
    end

    # Returns a sorted array based on user preference in HTTP_ACCEPT_LANGUAGE.
    # Browsers send this HTTP header, so don't think this is holy.
    #
    # Example:
    #
    # request.user_preferred_languages
    # # => [ 'nl-NL', 'nl-BE', 'nl', 'en-US', 'en' ]
    #
    def preferred_languages
      return @user_prefered_languages if @user_prefered_languages
      @user_prefered_languages=@accept.split(/\s*,\s*/).collect do |l|
        l += ';q=1.0' unless l =~ /;q=\d+\.\d+$/
        l.split(';q=')
      end.sort do |x, y|
        raise "Not correctly formatted" unless x.first =~ /^[a-z\-]+$/i
        y.last.to_f <=> x.last.to_f
      end.collect do |l|
        l.first.downcase.gsub(/-[a-z]+$/i) { |x| x.upcase }
      end
    rescue # Just rescue anything if the browser messed up badly.
      @user_prefered_languages=[]
    end


    # Finds the locale specifically requested by the browser.
    #
    # Example:
    #
    # request.preferred_language_from I18n.available_locales
    # # => 'nl'
    #
    def preferred_language_from(array)
      (preferred_languages & array.collect { |i| i.to_s }).first
    end

    # Returns the first of the user_preferred_languages that is compatible
    # with the available locales. Ignores region.
    #
    # Example:
    #
    # request.compatible_language_from I18n.available_locales
    #
    def compatible_language_from(available_languages)
      preferred_languages.map do |x| #en-US
        available_languages.find do |y| # en
          y = y.to_s
          x == y || x.split('-', 2).first == y.split('-', 2).first
        end
      end.compact.first
    end

  end #class
end #module
