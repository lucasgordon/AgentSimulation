class ChangeConversations < ActiveRecord::Migration[7.1]
  def change
    remove_column :conversations, :message, :text
    add_column :conversations, :model_ids, :string
  end
end
