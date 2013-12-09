class CreateFeedStatuses < ActiveRecord::Migration
  def change
    create_table :feed_status do |t|
      t.string :name,:null => false
      t.string :label, :null => false
    end
  end
end
