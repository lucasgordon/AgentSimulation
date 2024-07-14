class UpdateConversationsTable < ActiveRecord::Migration[7.1]
  def change
    remove_column :conversations, :agent_id, :integer
    remove_column :conversations, :model_ids, :string
    add_column :conversations, :title, :string
  end
end
