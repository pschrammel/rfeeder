require 'p_schrammel_utils/enum_reader'

namespace :db do
  namespace :enums do
    desc "update the configured enums"
    task :load => [:environment] do
      require Rails.root.join("config","enums")
      PSchrammelUtils::EnumReader::Config.update
    end
  end
end