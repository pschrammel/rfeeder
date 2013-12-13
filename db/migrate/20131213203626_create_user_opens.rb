class CreateUserOpens < ActiveRecord::Migration
  def self.up
    create_table :user_opens do |t|
      t.timestamp :last_opened_at,:null=>false
      t.integer :user_id,:null => false
      t.integer :story_id,:null => false
    end
    add_foreign_key :user_opens, :user_id,:users
    add_foreign_key :user_opens, :story_id,:stories
    add_index :user_opens, [:user_id,:story_id],:unique => true
  end
end
