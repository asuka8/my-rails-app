class CreateNotifications < ActiveRecord::Migration[8.1]
  def change
    create_table :notifications do |t|
      t.integer :visitor_id
      t.integer :visited_id
      t.integer :post_id
      t.string :action
      t.boolean :checked

      t.timestamps
    end
  end
end
