class AddProfileFieldsToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :nickname, :string
    add_column :users, :introduction, :text
  end
end
