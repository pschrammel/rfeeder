class DropNotNullForUserOpens < ActiveRecord::Migration
  def up
    execute("ALTER TABLE user_opens ALTER column  last_opened_at DROP NOT NULL")
    
  end
end
