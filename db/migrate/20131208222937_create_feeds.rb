class CreateFeeds < ActiveRecord::Migration
  def change
    create_table :feeds do |t|
      t.string :name    ,:null => false
      t.text :url, :null => false
      t.timestamp :last_fetched_at
      t.integer :feed_status_id, :null => false

      t.timestamps
    end
    add_index :feeds, :url, unique: true
    add_foreign_key :feeds,:feed_status_id,:feed_status
  end
end
