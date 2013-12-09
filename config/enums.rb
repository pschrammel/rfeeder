# -*- encoding : utf-8 -*-

db_path=Rails.root.join('db','enums')

PSchrammelUtils::EnumReader::Config.create do |config|

  config.add('feed_status',db_path.join('feed_status.csv'),FeedStatus)

end
