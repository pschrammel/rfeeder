# -*- encoding : utf-8 -*-
module PSchrammelUtils
  class GeoIP
    def self.database=(path)
      @database_path=path
      @database =::GeoIP.new(path)
    end

    def self.database
      @database ||= ::GeoIP.new(configatron.geoip.path) #needed for testing as this is reloaded
    end

    def self.lookup(ip)
      result=database.city(ip)
      if result
        self.new(
            :hostname => result[0], #188-126-68-216.cust.vpntunnel.org
            :ip => result[1], #"188.126.68.216"
            :country_code2 => result[2], #"SE"
            :country_code3 => result[3], # "SWE"
            :country_name_en => result[4], # "Sweden"
            :continent => result[5], #"EU"
            :unknown1 => result[6], #28 region name
            :city_name => result[7], #Lane city_name
            :unknown3 => result[8], #"" postal code
            :latitude => result[9], #  58.41669999999999
            :longitude => result[10], # 12.016699999999986
            :unknown4 => result[11], #nil usa dma code
            :unknown5 => result[12], #nil usa area code
            :time_zone => result[13] #"Europe/Stockholm"

        )
      else
        new(:ip => ip)
      end
    end

    attr_reader :hostname, :ip, :geoip_country_id, :country_code2, :country_code3, :country_name_en, :continent,
                :city_name, :latitude,
                :longitude, :time_zone, :created_at

    def initialize(options={})
      PSchrammelUtils::Setter.instance_var(self, options)
      @created_at=Time.now
    end


  end
end
