require 'ostruct'
module PSchrammelUtils
  def self.simple_config
    @simple_config ||= OpenStruct.new
  end
end