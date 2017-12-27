# == Schema Information
#
# Table name: feed_status
#
#  id    :integer          not null, primary key
#  name  :string(255)      not null
#  label :string(255)      not null
#

class FeedStatus < ActiveRecord::Base
  self.table_name="feed_status"
end
