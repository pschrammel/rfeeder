class AddReadLaterAtToUserOpens < ActiveRecord::Migration
  def change
    add_column :user_opens, :read_later_at, :timestamp
    add_index :user_opens, :read_later_at
  end
end
