class CreateStories < ActiveRecord::Migration
  def change
    create_table :stories do |t|
      t.text :title
      t.text :permalink
      t.text :body
      t.text :entry_id

      t.integer :feed_id, :null => false
      t.timestamp :published

      t.boolean :is_read, :default => false,:null => false
      t.boolean :is_starred, :default => false, :null => false
      t.boolean :keep_unread, :default => false

      t.timestamps
    end
    add_index :stories, [:permalink, :feed_id], unique: true
    add_foreign_key :stories, :feed_id, :feeds
  end
end
